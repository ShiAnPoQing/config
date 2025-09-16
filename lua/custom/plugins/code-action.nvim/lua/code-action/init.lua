local M = {}
local Win = require("code-action.window")

local function fixed_row(max_height)
  local row
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local cursor_row = vim.fn.line(".")
  if wininfo.botline - cursor_row < max_height then
    row = -max_height - 2
  end

  return row
end

local function exec_code_action(client_id, code_action)
  if code_action.edit then
    vim.lsp.util.apply_workspace_edit(code_action.edit, "utf-16")
  end
  if code_action.command then
    local Client = vim.lsp.get_client_by_id(client_id)
    if not Client then
      return
    end
    Client:exec_cmd(code_action.command)
  end
end

--- @class CodeActionOptions

function M.show()
  M.request_code_action({
    bufnr = vim.api.nvim_get_current_buf(),
    callback = function(actions)
      M.code_action(actions)
    end,
  })
end

--- @class RequestCodeActionOptions
--- @field bufnr number
--- @field callback function

--- @param options RequestCodeActionOptions
function M.request_code_action(options)
  local params = vim.lsp.util.make_range_params(0, "utf-8")
  local diagnostics = vim.diagnostic.get(options.bufnr)
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local diagnostic
  for _, v in ipairs(diagnostics) do
    if v.lnum + 1 >= current_line then
      diagnostic = v
      break
    end
  end
  params.context = { diagnostics = { diagnostic } }
  vim.lsp.buf_request_all(0, "textDocument/codeAction", params, function(results)
    local actions = {}
    for _, v in ipairs(results) do
      for _, code_action in ipairs(v.result or {}) do
        local title = code_action.title
        actions[#actions + 1] = {
          title = title,
          callback = function()
            exec_code_action(v.context.client_id, code_action)
          end,
        }
      end
    end
    options.callback(actions)
  end)
end

function M.code_action(actions)
  local lines = {}
  local max_width = 0
  for _, action in ipairs(actions) do
    lines[#lines + 1] = action.title
    max_width = math.max(max_width, #action.title)
  end
  max_width = max_width + 4
  local max_height = math.min(vim.o.lines - vim.o.cmdheight - 1, #actions)

  local config = {
    width = max_width,
    height = max_height,
    title = "Code Actions[" .. #actions .. "]",
    title_pos = "center",
  }
  local row = fixed_row(max_height)
  if row then
    config.row = row
  end

  Win:open({
    config = config,
    lines = lines,
  })

  vim.keymap.set("n", "<cr>", function()
    local callback = actions[vim.fn.line(".")].callback
    callback()
    Win:close()
  end, { buffer = Win.buf })
  vim.keymap.set("n", "q", function()
    Win:close()
  end, { buffer = Win.buf })
  vim.keymap.set("n", "<esc>", function()
    Win:close()
  end, { buffer = Win.buf })

  vim.api.nvim_create_autocmd("WinLeave", {
    callback = function()
      Win:close()
      return true
    end,
  })
end

--- @param options? CodeActionOptions
function M.setup(options) end

return M

-- /**
--  * 代码操作（CodeAction）表示可在代码中执行的变化，例如用于修复问题或重构代码。
--  *
--  * 一个 CodeAction 必须设置 `edit` 和/或 `command`。如果两者都提供了，
--  * 则会先应用 `edit`，然后执行 `command`。
--  */
-- export interface CodeAction {
--
-- 	/**
-- 	 * 此代码操作的简短、人类可读的标题。
-- 	 */
-- 	title: string;
--
-- 	/**
-- 	 * 代码操作的类型（种类）。
-- 	 *
-- 	 * 用于筛选代码操作。
-- 	 */
-- 	kind?: CodeActionKind;
--
-- 	/**
-- 	 * 此代码操作所解决的诊断信息。
-- 	 */
-- 	diagnostics?: Diagnostic[];
--
-- 	/**
-- 	 * 将此操作标记为首选操作。首选操作由 `auto fix` 命令使用，并可以作为键绑定的目标。
-- 	 *
-- 	 * 如果一个快速修复（quick fix）能正确解决根本错误，则应将其标记为首选。
-- 	 * 如果一个重构（refactoring）是最合理的操作选择，则应将其标记为首选。
-- 	 *
-- 	 * @since 3.15.0
-- 	 */
-- 	isPreferred?: boolean;
--
-- 	/**
-- 	 * 标记此代码操作当前无法应用。
-- 	 *
-- 	 * 关于被禁用的代码操作，客户端应遵循以下指南：
-- 	 *
-- 	 * - 被禁用的代码操作不会显示在自动灯泡（lightbulb）代码操作菜单中。
-- 	 *
-- 	 * - 当用户请求更特定类型的代码操作（例如重构）时，被禁用的操作在代码操作菜单中显示为灰色。
-- 	 *
-- 	 * - 如果用户有一个键绑定可以自动应用代码操作，但返回的只有被禁用的代码操作，
-- 	 *   则客户端应在编辑器中向用户显示包含 `reason` 的错误消息。
-- 	 *
-- 	 * @since 3.16.0
-- 	 */
-- 	disabled?: {
--
-- 		/**
-- 		 * 人类可读的描述，说明代码操作当前被禁用的原因。
-- 		 *
-- 		 * 这会显示在代码操作 UI 中。
-- 		 */
-- 		reason: string;
-- 	};
--
-- 	/**
-- 	 * 此代码操作执行的工作空间编辑（WorkspaceEdit）。
-- 	 */
-- 	edit?: WorkspaceEdit;
--
-- 	/**
-- 	 * 此代码操作执行的命令（Command）。如果一个代码操作
-- 	 * 同时提供了编辑（edit）和命令（command），则先执行编辑，
-- 	 * 然后执行命令。
-- 	 */
-- 	command?: Command;
--
-- 	/**
-- 	 * 一个数据条目字段，在 `textDocument/codeAction` 请求和
-- 	 * `codeAction/resolve` 请求之间会保留此代码操作上的该字段。
-- 	 *
-- 	 * @since 3.16.0
-- 	 */
-- 	data?: LSPAny;
-- }
