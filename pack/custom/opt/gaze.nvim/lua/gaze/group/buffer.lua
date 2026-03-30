local Node = require("gaze.group.node")

--- @class Gaze.GroupBuffer: Gaze.GroupNode
--- @field buf integer
--- @field config Gaze.BufferGroup.Config
local M = setmetatable({}, { __index = Node })
M.__index = M

--- @param group Gaze.BufferGroup
--- @param parent Gaze.GroupRoot
function M:new(group, parent)
  local o = Node.new(self, nil, parent) --[[@as Gaze.GroupBuffer]]
  o.buf = group.buf
  o.config = {
    label = group.label,
    layer = group.layer,
    buf = group.buf,
  }
  o:_register(group)
  return o
end

return M
