local Response = require("lsp-layer.code_action.response")
local U = require("lsp-layer.code_action.utils")

--- @class LspLayer.CodeAction
local M = {}

--- @class LspLayer.CodeActionOpts
--- @field context? lsp.CodeActionContext

--- @param opts? LspLayer.CodeActionOpts
--- @return LspLayer.CodeAction.Response
function M:request(opts)
  opts = opts or {}
  local RS = Response:new()
  local context = U.create_code_action_context(opts.context)
  local bufnr = vim.api.nvim_get_current_buf()
  local mode = vim.api.nvim_get_mode().mode
  local win = vim.api.nvim_get_current_win()
  local Method = vim.lsp.protocol.Methods.textDocument_codeAction
  local clients = vim.lsp.get_clients({ bufnr = bufnr, method = Method })
  if not next(clients) then
    vim.notify(vim.lsp._unsupported_method(Method), vim.log.levels.WARN)
    return RS
  end
  local function params_provider(client)
    return U.create_code_action_params(client, context, win, bufnr, mode)
  end
  local function handle(results)
    RS:receive(results, opts)
  end
  vim.lsp.buf_request_all(bufnr, Method, params_provider, handle)
  return RS
end

return M
