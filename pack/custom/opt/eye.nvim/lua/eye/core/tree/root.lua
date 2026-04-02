local U = require("eye.core.util")
local Node = require("eye.core.tree.node")
local Leaf = require("eye.core.tree.leaf")

--- @class Eye.Root.Handle
--- @field BeforeNodeStart fun()[]
--- @field LeafCreatePost fun()[]
--- @field BuildPost fun()[]

--- @alias Eye.Root.Event "BeforeNodeStart"|"LeafCreatePost"

--- @class Eye.Root: Eye.Node
--- @field config Eye.Config
--- @field bufs table<string, boolean>
--- @field ns_id integer
--- @field handle Eye.Root.Handle
local M = setmetatable({}, { __index = Node })
M.__index = M

local ns_id = vim.api.nvim_create_namespace("eye-namespace")

--- @return string|nil
local function get_random_label(include, node)
  if #vim.tbl_keys(node.children) >= #include or node.remain == 0 then
    return
  end

  local random = math.random(#include)
  local label = include[random]
  if node.children[label] == nil then
    return label
  end

  return get_random_label(include, node)
end

--- @param config Eye.Config
--- @return Eye.Root
function M:new(config)
  local root = Node.new(self) --[[@as Eye.Root]]
  local level, remain1, remain2 = U.compute(#config.label.include, #config.labels)
  root.type = "root"
  root.root = root
  root.id = "0"
  root.level = level + 1
  root.remain = remain2 + 1
  root.config = config
  root.bufs = {}
  root.handle.BeforeNodeStart = {}
  root.handle.LeafCreatePost = {}
  root.handle.BuildPost = {}
  root.current = Node:new(root, "[[empty]]", remain1)
  setmetatable(root.children, { __index = root.current.children })
  return root
end

function M:build()
  for _, label in ipairs(self.config.labels or {}) do
    self.bufs[tostring(label.buf)] = true
    self:_build(self.current, label)
  end
  self:emit("BuildPost")
end

--- @param node Eye.Node
--- @param label Eye.Label.Spec
function M:_build(node, label)
  local include = self.config.label.include
  if not node then
    return
  end

  local function build(n)
    self:_build(n, label)
  end

  local function transfer()
    if node.parent then
      node.parent.current = nil
      build(node.parent)
    end
  end

  if node.level == 1 then
    if node.remain == 0 then
      transfer()
      return
    end
    local leaf = Leaf:new(node, get_random_label(include, node), #include)
    self:emit("LeafCreatePost", leaf, label, self.config.label)
    return
  end

  if node.current then
    build(node.current)
    return
  end

  if node.remain == 0 then
    transfer()
    return
  end

  node.current = Node:new(node, get_random_label(include, node), #include)
  build(node.current)
end

--- @param target Eye.Node | Eye.Leaf | Eye.Root
function M:before_node_start(target)
  if target.type == "root" then
    U.try(self.config.start)
  end
  self:emit("BeforeNodeStart")
end

function M:clear_namespace()
  for buf, _ in pairs(self.bufs or {}) do
    vim.api.nvim_buf_clear_namespace(tonumber(buf) --[[@as integer]], self:get_ns_id(), 0, -1)
  end
end

--- @param target Eye.Node | Eye.Leaf | Eye.Root
--- @param state "interrupted"| "uninterrupted"
function M:after_node_finish(target, state, ctx)
  self:clear_namespace()
  if state == "interrupted" then
    if target.type == "leaf" then
      U.try(self.config.completed, ctx)
      U.try(self.config.finish, vim.tbl_deep_extend("force", ctx, { completed = true }))
    else
      U.try(self.config.cancelled, ctx)
      U.try(self.config.finish, vim.tbl_deep_extend("force", ctx, { completed = false }))
    end
  else
    -- Node is uninterrupted do something
  end
end

function M.get_ns_id()
  return ns_id
end

return M
