local Component = require("pulseline.component")

--- @alias PulseLine.ConfigStatusline fun(statusline: PulseLine.Statusline)

--- @class PulseLine.Statusline:PulseLine.Component
--- @field [string] any
local M = setmetatable({}, { __index = Component })
M.__index = M

function M:new()
  local o = Component.new(self)
  return o --[[@as PulseLine.Statusline]]
end

return M
