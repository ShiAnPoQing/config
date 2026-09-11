local M = {}
local Statusline = require("pulseline.statusline")
local Component = require("pulseline.component")

--- @class PulseLine.Config
--- @field statusline PulseLine.Statusline

--- @param config? PulseLine.Config
function M.setup(config)
  config = config or {}
  require("pulseline.core").build(Statusline)
end

--- @param config PulseLine.ConfigStatusline
function M.Statusline(config)
  local S = Statusline:new()
  config(S)
  return S
end

function M.Component(config)
  local C = Component:new()
  config(C)
  return C
end

return M
