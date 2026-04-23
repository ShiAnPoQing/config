local Response = require("lsp-layer.code_action.response")

--- @class LspLayer.CodeAction.Request
local M = {}

---@class LspLayer.CodeAction.RequestOpts

---@param opts LspLayer.CodeAction.RequestOpts
---@return LspLayer.CodeAction.Response
function M:request(opts)
  return setmetatable({}, Response)
end

M:request({}):filter():run()

return M
