local Node = require("gaze.label.node")

--- @class Gaze.LabelRoot: Gaze.LabelNode
local M = setmetatable({}, { __index = Node })
M.__index = M

--- @param pendings Gaze.LabelLeaf.Pending[]
function M:new(pendings)
  local root = Node.new(self) --[[@as Gaze.LabelRoot]]
  root:_register(pendings)
  return root
end

--- @param pendings Gaze.LabelLeaf.Pending[]
function M:_register(pendings)
  vim.print(pendings)
end

function M:_build() end

function M:gaze() end

return M
