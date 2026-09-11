--- @class _Eye.Node
--- @field type string
--- @field label string
--- @field children table<string, _Eye.Node|_Eye.Leaf>
--- @field tree _Eye.Tree
--- @field parent? _Eye.Node
--- @field actived? boolean|nil
local M = {}
M.__index = M

--- @class _Eye.Node.Opts
--- @field parent? _Eye.Node
--- @field label string
--- @field tree? _Eye.Tree

--- @param opts _Eye.Node.Opts
function M:new(opts)
  local o = setmetatable({}, self)
  o.parent = opts.parent
  o.label = opts.label
  o.type = "node"
  if o.parent then
    o.parent.children[o.label] = o
    o.tree = o.parent.tree
  end
  o.children = {}
  return o
end

return M
