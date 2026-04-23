local Response = require("lsp-layer.code_action.response")

--- @class LspLayer.CodeAction
local M = {}

--- @class LspLayer.CodeActionOpts
--- @field context? lsp.CodeActionContext

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
    end_col, start_col = start_col, end_col --- @type integer, integer
  elseif end_row < start_row then
    start_row, end_row = end_row, start_row --- @type integer, integer
    start_col, end_col = end_col, start_col --- @type integer, integer
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

--- @param opts LspLayer.CodeActionOpts
--- @return LspLayer.CodeAction.Response
function M:request(opts)
  local RS = Response:new()
  local context = opts.context and vim.deepcopy(opts.context) or {}
  if not context.triggerKind then
    context.triggerKind = vim.lsp.protocol.CodeActionTriggerKind.Invoked
  end
  local bufnr = vim.api.nvim_get_current_buf()
  local mode = vim.api.nvim_get_mode().mode
  local win = vim.api.nvim_get_current_win()
  local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/codeAction" })

  if not next(clients) then
    vim.notify(vim.lsp._unsupported_method("textDocument/codeAction"), vim.log.levels.WARN)
    return RS
  end

  vim.lsp.buf_request_all(bufnr, "textDocument/codeAction", function(client)
    ---@type lsp.CodeActionParams
    local params
    if mode == "v" or mode == "V" then
      local range = range_from_selection(bufnr, mode)
      params = vim.lsp.util.make_given_range_params(range.start, range["end"], bufnr, client.offset_encoding)
    else
      params = vim.lsp.util.make_range_params(win, client.offset_encoding)
    end

    --- @cast params lsp.CodeActionParams

    if context.diagnostics then
      params.context = context
    else
      local ns_push = vim.lsp.diagnostic.get_namespace(client.id)
      local diagnostics = {}
      local lnum = vim.api.nvim_win_get_cursor(0)[1] - 1

      client:_provider_foreach("textDocument/diagnostic", function(cap)
        local ns_pull = vim.lsp.diagnostic.get_namespace(client.id, true, cap.identifier)
        vim.list_extend(diagnostics, vim.diagnostic.get(bufnr, { namespace = ns_pull, lnum = lnum }))
      end)

      vim.list_extend(diagnostics, vim.diagnostic.get(bufnr, { namespace = ns_push, lnum = lnum }))
      params.context = vim.tbl_extend("force", context, {
        diagnostics = vim.tbl_map(function(d)
          return d.user_data.lsp
        end, diagnostics),
      })
    end
    return params
  end, function(results)
    RS:receive(results, opts)
  end)

  return RS
end

return M
