--- @class Gaze.GroupNode
--- @field parent Gaze.GroupNode|nil
--- @field children Gaze.GroupNode[]
--- @field leafs Gaze.LabelLeaf[]
--- @field config Gaze.Group.Config
local M = {}
M.__index = M

--- @param groups Gaze.Group.Groups
function M:_register(groups)
  for _, group in ipairs(groups) do
    if type(group.items) == "table" then
      local label_spec = group --[[@as Gaze.LabelSpec]]
      self:find_root():_append_pending({
        spec = label_spec,
        callback = function(leaf)
          self.leafs[#self.leafs + 1] = leaf
        end,
      })
    else
      self.children[#self.children + 1] = M:new(group --[[@as Gaze.Group]], self)
    end
  end
end

--- @param group Gaze.Group|nil
--- @param parent Gaze.GroupNode|nil
function M:new(group, parent)
  local o = setmetatable({}, self)
  o.parent = parent
  o.leafs = {}
  o.children = {}
  if group then
    o.config = group
    o:_register(group)
  end
  return o
end

--- @return Gaze.GroupRoot
function M:find_root()
  local node = self
  while node.parent do
    node = node.parent
  end
  return node --[[@as Gaze.GroupRoot]]
end

function M:highlight()
  for _, leaf in ipairs(self.leafs) do
    leaf:highlight()
  end
  for _, child in ipairs(self.children) do
    child:highlight()
  end
end

return M
