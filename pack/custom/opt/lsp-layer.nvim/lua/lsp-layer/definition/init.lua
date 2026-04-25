local U = require("lsp-layer.definition.utils")
local Response = require("lsp-layer.definition.response")

---@class LspLayer.Definition
local M = {}

---@class LspLayer.DefinitionOpts

---@param opts? LspLayer.DefinitionOpts
function M:request(opts)
  local RS = Response:new()
  opts = opts or {}
  local bufnr = vim.api.nvim_get_current_buf()
  local win = vim.api.nvim_get_current_win()
  local method = vim.lsp.protocol.Methods.textDocument_definition

  local clients = vim.lsp.get_clients({ method = method, bufnr = bufnr })
  if not next(clients) then
    vim.notify(vim.lsp._unsupported_method(method), vim.log.levels.WARN)
    return RS
  end
  vim.lsp.buf_request_all(bufnr, method, function(client)
    local params = vim.lsp.util.make_position_params(win, client.offset_encoding)
    params.context = { includeDeclaration = true }
    return params
  end, function(results)
    RS:receive(results, {
      opts = opts,
      bufnr = bufnr,
      win = win,
      method = method,
    })
  end)
  return RS
end

return M
