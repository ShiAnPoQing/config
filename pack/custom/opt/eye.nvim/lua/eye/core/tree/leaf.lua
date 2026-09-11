local Node = require("eye.core.tree.node")

--- @class Eye.Leaf.Handle
--- @field Highlight fun()[]

--- @class Eye.Leaf: Eye.Node
--- @field Label Eye.Label
--- @field handle Eye.Leaf.Handle
local M = setmetatable({}, { __index = Node })
M.__index = M

--- @param targets Eye.Node[]
function M:highlight(targets)
  table.insert(targets, self)
  table.remove(targets, 1)
  self:emit("Highlight", targets)
end

function M:spread(targets)
  table.insert(targets, self)
  table.remove(targets, 1)
end

--- @param parent Eye.Node|nil
--- @param label string|nil
--- @param remain integer|nil
function M:new(parent, label, remain)
  local o = Node.new(self, parent, label, remain) --[[@as Eye.Leaf]]
  o.type = "leaf"
  o.level = 0
  o.handle.Highlight = {}
  return o
end

function M:start()
  self:finish()
end

function M:finish()
  Node.finish(self, self.Label:matched())
end

return M
