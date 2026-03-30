local Node = require("gaze.label.node")

--- @class Gaze.LabelLeaf.Pending
--- @field spec Gaze.LabelSpec
--- @field callback fun(leaf: Gaze.LabelLeaf)

--- @class Gaze.LabelLeaf: Gaze.LabelNode
local M = setmetatable({}, { __index = Node })
M.__index = M

--- @param pending Gaze.LabelLeaf.Pending
function M:new(parent, pending)
  local leaf = Node.new(self, parent) --[[@as Gaze.LabelLeaf]]
  pending.callback(leaf)
  return leaf
end

function M:highlight()
  local parent = self.parent

  local root
end

return M
