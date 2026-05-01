---@class LspLayer.CodeAction._Transform
---@field response LspLayer.CodeAction.Action[]
local M = {}

---@param filter fun(x: lsp.CodeAction|lsp.Command, client_id: integer): boolean
---@return LspLayer.CodeAction.Action[]
function M:filter(filter)
  vim.validate("filter", filter, "function", true)
  local response = {}
  for _, action in ipairs(self.response) do
    if filter(action.action, action.ctx.client_id) then
      table.insert(response, action)
    end
  end
  return response
end

return M
