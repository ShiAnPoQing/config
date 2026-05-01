local M = {}

---@param bufnr integer
---@param mode "v"|"V"
---@return table {start={row,col}, end={row,col}} using (1, 0) indexing
local function range_from_selection(bufnr, mode)
  -- [bufnum, lnum, col, off]; both row and column 1-indexed
  local start = vim.fn.getpos("v")
  local end_ = vim.fn.getpos(".")
  local start_row = start[2]
  local start_col = start[3]
  local end_row = end_[2]
  local end_col = end_[3]

  -- A user can start visual selection at the end and move backwards
  -- Normalize the range to start < end
  if start_row == end_row and end_col < start_col then
    end_col, start_col = start_col, end_col ---@type integer, integer
  elseif end_row < start_row then
    start_row, end_row = end_row, start_row ---@type integer, integer
    start_col, end_col = end_col, start_col ---@type integer, integer
  end
  if mode == "V" then
    start_col = 1
    local lines = vim.api.nvim_buf_get_lines(bufnr, end_row - 1, end_row, true)
    end_col = #lines[1]
  end
  return {
    ["start"] = { start_row, start_col - 1 },
    ["end"] = { end_row, end_col - 1 },
  }
end

---@param client vim.lsp.Client
---@param bufnr integer
---@return lsp.Diagnostic[]
local function create_diagnostics(client, bufnr)
  local ns_push = vim.lsp.diagnostic.get_namespace(client.id)
  local diagnostics = {}
  local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1

  client:_provider_foreach("textDocument/diagnostic", function(cap)
    local ns_pull = vim.lsp.diagnostic.get_namespace(client.id, true, cap.identifier)
    vim.list_extend(diagnostics, vim.diagnostic.get(bufnr, { namespace = ns_pull, lnum = lnum }))
  end)
  vim.list_extend(diagnostics, vim.diagnostic.get(bufnr, { namespace = ns_push, lnum = lnum }))
  diagnostics = vim.tbl_map(function(d)
    return d.user_data.lsp
  end, diagnostics)
  return diagnostics
end

---@return lsp.CodeActionContext
function M.create_code_action_context(ctx)
  local context = ctx and vim.deepcopy(ctx) or {}
  if not context.triggerKind then
    context.triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked
  end
  return context
end

---@param client vim.lsp.Client
---@param context lsp.CodeActionContext
---@param win integer
---@param bufnr integer
---@param mode string
function M.create_code_action_params(client, context, win, bufnr, mode)
  ---@type lsp.CodeActionParams
  local params
  if mode == "v" or mode == "V" then
    local range = range_from_selection(bufnr, mode)
    params = vim.lsp.util.make_given_range_params(range.start, range["end"], bufnr, client.offset_encoding)
  else
    params = vim.lsp.util.make_range_params(win, client.offset_encoding)
  end
  ---@cast params lsp.CodeActionParams
  if context.diagnostics then
    params.context = context
  else
    params.context = vim.tbl_extend("force", context, { diagnostics = create_diagnostics(client, bufnr) })
  end
  return params
end

---@param action lsp.Command|lsp.CodeAction
---@param client vim.lsp.Client
---@param ctx lsp.HandlerContext
local function apply_action(action, client, ctx)
  if action.edit then
    vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
  end
  local a_cmd = action.command
  if a_cmd then
    local command = type(a_cmd) == "table" and a_cmd or action
    ---@cast command lsp.Command
    client:exec_cmd(command, ctx)
  end
end

---@param choice LspLayer.CodeAction.Action
function M.on_user_choice(choice)
  if not choice then
    return
  end
  local client = assert(vim.lsp.get_client_by_id(choice.ctx.client_id))
  local action = choice.action
  local bufnr = assert(choice.ctx.bufnr, "Must have buffer number")
  if type(action.title) == "string" and type(action.command) == "string" then
    apply_action(action, client, choice.ctx)
    return
  end
  if action.disabled then
    vim.notify(action.disabled.reason, vim.log.levels.ERROR)
    return
  end
  if not (action.edit and action.command) and client:supports_method("codeAction/resolve") then
    client:request("codeAction/resolve", action, function(err, resolved_action)
      if err then
        -- If resolve fails, try to apply the edit/command from the original code action.
        if action.edit or action.command then
          apply_action(action, client, choice.ctx)
        else
          vim.notify(err.code .. ": " .. err.message, vim.log.levels.ERROR)
        end
      else
        apply_action(resolved_action, client, choice.ctx)
      end
    end, bufnr)
  else
    apply_action(action, client, choice.ctx)
  end
end

return M
