--- @class Eye.Node
--- @field id string
--- @field level integer
--- @field remain integer
--- @field parent? Eye.Node
--- @field children table<string, Eye.Node|Eye.Leaf>
--- @field label? string
--- @field current? Eye.Node
local M = {}
M.__index = M

function M:start()
  local root = self:find_root()
  root:layer()
  self:highlight({})
  vim.cmd.redraw()
  local char = vim.fn.getcharstr()
  local next = self.children[char]
  root:refresh()
  if next then
    next:start()
  else
    self:finish({ matched = false, label = vim.fn.keytrans(char) })
  end
end

function M:finish(ctx)
  self:find_root():finish(ctx)
end

--- @param parent Eye.Node|nil
--- @param label string|nil
--- @param remain integer|nil
function M:new(parent, label, remain)
  local o = setmetatable({}, self)
  if parent then
    o.id = parent.id .. (#vim.tbl_keys(parent.children) + 1)
    o.level = parent.level - 1
    parent.children[label] = o
    parent.remain = parent.remain - 1
  end
  o.parent = parent
  o.label = label
  o.children = {}
  if remain then
    o.remain = remain
  end
  return o
end

function M:find_root()
  local node = self
  while node.parent do
    node = node.parent
  end
  return node --[[@as Eye.Root]]
end

--- @param targets Eye.Node[]
function M:highlight(targets)
  if self.label ~= "[[empty]]" then
    table.insert(targets, self)
  end
  for _, child in pairs(self.children or {}) do
    child:highlight(vim.tbl_extend("force", targets, {}))
  end
end

return M
