--- @alias Eye.Node.Handle table<string, fun(...)[]>

--- @class Eye.Node
--- @field type "node" | "leaf" | "root"
--- @field id string
--- @field level integer
--- @field remain integer
--- @field parent? Eye.Node
--- @field root Eye.Root
--- @field children table<string, Eye.Node|Eye.Leaf>
--- @field label? string
--- @field current? Eye.Node
--- @field handle Eye.Node.Handle
local M = {}
M.__index = M

--- @param parent Eye.Node|nil
--- @param label string|nil
--- @param remain integer|nil
function M:new(parent, label, remain)
  local o = setmetatable({}, self) --[[@as Eye.Node]]
  o.type = "node"
  if parent then
    o.id = parent.id .. (#vim.tbl_keys(parent.children) + 1)
    o.level = parent.level - 1
    o.parent = parent
    o.root = parent.root
    parent.children[label] = o
    parent.remain = parent.remain - 1
  end
  o.label = label
  o.children = {}
  if remain then
    o.remain = remain
  end
  o.handle = {
    Finish = {},
  }
  return o
end

--- @param event string
function M:on(event, callback)
  if type(event) ~= "string" then
    return
  end
  if self.handle[event] then
    self.handle[event][#self.handle[event] + 1] = callback
  end
end

--- @param event string
function M:emit(event, ...)
  if type(event) ~= "string" then
    return
  end
  if self.handle[event] then
    for _, cb in ipairs(self.handle[event]) do
      cb(...)
    end
  end
end

function M:start()
  self.root:before_node_start(self)
  self:highlight({})
  self:spread({})
  vim.cmd.redraw()
  local char = vim.fn.getcharstr()
  self:finish({ char = vim.fn.keytrans(char) })
end

function M:spread(targets)
  if self.label ~= "[[empty]]" then
    table.insert(targets, self)
  end
  for _, child in pairs(self.children or {}) do
    child:spread(vim.tbl_extend("force", targets, {}))
  end
end

--- @param ctx table
function M:finish(ctx)
  local next = self.children[ctx.char]
  if not next then
    self.root:after_node_finish(self, "interrupted", ctx)
  else
    self.root:after_node_finish(self, "uninterrupted", ctx)
    next:start()
  end
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
