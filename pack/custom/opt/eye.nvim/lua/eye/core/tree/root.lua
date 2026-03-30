local U = require("eye.core.util")
local Config = require("eye.core.config")
local Node = require("eye.core.tree.node")
local Leaf = require("eye.core.tree.leaf")
local Layer = require("eye.core.layer")

--- @class Eye.Root: Eye.Node
--- @field config Eye.RootGroup.Config
--- @field leaf_pendings Eye.Leaf.Pending[]
--- @field layer_pendings Eye.Layer.Pending[]
--- @field bufs integer[]
--- @field layer_specs Eye.Config.LayerSpec[]
local M = setmetatable({}, { __index = Node })
M.__index = M

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

--- @param node Eye.Node
--- @param leaf_pending Eye.Leaf.Pending
function M:_build(node, leaf_pending)
  local include = self.config.label.include
  if not node then
    return
  end

  local function build(n)
    self:_build(n, leaf_pending)
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
    Leaf:new(node, get_random_label(include, node), #include, leaf_pending)
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

function M:_register()
  for _, v in ipairs(self.leaf_pendings) do
    self:_build(self.current, v)
  end
end

--- @param mixed_table Eye.Config
function M:_prepare(mixed_table)
  mixed_table = vim.tbl_deep_extend("force", {
    root = true,
  }, mixed_table or {})

  local function callback_buffer_level(mt, ctx)
    local config = Config:proxy(mt, ctx.config)
    ctx.config = config
    ctx.buf = mt.buf
    self.bufs[#self.bufs + 1] = mt.buf

    if type(mt.layer) == "table" and #mt.layer > 0 then
      self.layer_pendings[#self.layer_pendings + 1] = {
        buf = mt.buf,
        config = config.layer,
        specs = ctx.config.layer,
      }
    end
    return ctx
  end

  local function callback_root_level(mt, ctx)
    local config = Config:proxy(mt)
    self.config = config
    if type(mt.layer) == "table" and #mt.layer > 0 then
      self.layer_specs = mt.layer
    end
    ctx.config = config
    return ctx
  end

  local function callback_leaf_level(mt, ctx)
    local label = mt --[[@as Eye.LabelSpec]]
    local config = Config.label:proxy(label, ctx.config.label)
    self.leaf_pendings[#self.leaf_pendings + 1] = {
      spec = {
        items = label.items,
        data = label.data,
        buf = ctx.buf,
      },
      config = config,
    }
  end

  local function callback(mt, ctx)
    ctx.config = Config:proxy(mt, ctx.config)
    return ctx
  end

  local function work(mt, ctx)
    if type(mt) ~= "table" then
      return
    end
    local function process(_mt, _ctx)
      for _, v in ipairs(_mt) do
        work(v, _ctx)
      end
    end
    if mt.root then
      process(mt, callback_root_level(mt, ctx))
      return
    end
    if type(mt.buf) == "number" then
      process(mt, callback_buffer_level(mt, ctx))
      return
    end
    if type(mt.items) == "table" then
      callback_leaf_level(mt, ctx)
      return
    end
    process(mt, callback(mt, ctx))
  end
  work(mixed_table, {})
end

--- @param config Eye.Config
--- @return Eye.Root
function M:new(config)
  local root = Node.new(self) --[[@as Eye.Root]]
  root.bufs = {}
  root.leaf_pendings = {}
  root.layer_pendings = {}
  root.layer_specs = {
    {
      range = function(c)
        return { c.topline - 1, c.botline }
      end,
    },
  }
  root:_prepare(config)
  local level, remain1, remain2 = U.compute(#root.config.label.include, #root.leaf_pendings)
  root.id = "0"
  root.level = level + 1
  root.remain = remain2 + 1
  root.current = Node:new(root, "[[empty]]", remain1)
  setmetatable(root.children, { __index = root.current.children })
  root:_register()
  return root
end

function M:start()
  U.try(self.config.start)
  Node.start(self)
end

function M:finish(ctx)
  if not ctx.matched then
    U.try(self.config.cancelled, ctx)
  else
    U.try(self.config.completed, ctx)
  end
  U.try(self.config.finish, ctx)
end

function M:refresh()
  for _, buf in ipairs(self.bufs) do
    vim.api.nvim_buf_clear_namespace(buf, require("eye.core").ns_id, 0, -1)
  end
end

function M:layer()
  if #self.layer_pendings > 0 then
    for _, pending in ipairs(self.layer_pendings) do
      Layer.draw(pending.buf, pending.specs, pending.config)
    end
  else
    for _, buf in ipairs(self.bufs) do
      Layer.draw(buf, self.layer_specs, self.config.layer)
    end
  end
end

return M
