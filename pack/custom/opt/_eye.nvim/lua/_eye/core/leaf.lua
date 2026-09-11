local Node = require("_eye.core.node")

--- @class _Eye.Leaf: _Eye.Node
--- @field type "leaf"
--- @field data any
local M = setmetatable({}, Node)
M.__index = M

--- @class _Eye.Leaf.Opts: _Eye.Node.Opts
--- @field data any

--- @param opts _Eye.Leaf.Opts
function M:new(opts)
  local o = Node.new(self, { label = opts.label, parent = opts.parent, tree = opts.tree })
  o.type = "leaf"
  o.data = opts.data
  return o
end

return M
