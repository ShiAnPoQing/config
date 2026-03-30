local Node = require("gaze.group.node")

--- @class Gaze.GroupRoot: Gaze.GroupNode
--- @field pendings Gaze.LabelLeaf.Pending[]
--- @field config Gaze.RootGroup.Config
local M = setmetatable({}, { __index = Node })
M.__index = M

--- @param group Gaze.Config
function M:new(group)
  group = vim.tbl_deep_extend("force", {}, group)
  local root = Node.new(self) --[[@as Gaze.GroupRoot]]
  root.pendings = {}
  root:_register(group)
  root.config = {
    label = group.label,
    layer = group.layer,
    start = group.start,
    finish = group.finish,
  }
  require("gaze.label.root"):new(self.pendings)
  return root
end

--- @param groups Gaze.RootGroup.Groups
function M:_register(groups)
  for index, group in ipairs(groups) do
    self.children[index] = require("gaze.group.buffer"):new(group, self)
  end
end

--- @param pending Gaze.LabelLeaf.Pending
function M:_append_pending(pending)
  self.pendings[#self.pendings + 1] = pending
end

return M
