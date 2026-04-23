---@class LspLayer.CodeAction._UI
--- @field response LspLayer.CodeAction.Action[]
local M = {}

function M:float()
  local response = self.response
end

function M:choice() end

return M
