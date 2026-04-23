local Run = require("lsp-layer.code_action.run")

---@class LspLayer.CodeAction.Response
local M = {}
M.__index = M

function M:filter()
  return setmetatable({}, Run)
end

return M
