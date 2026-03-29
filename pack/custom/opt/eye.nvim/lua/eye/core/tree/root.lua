local U = require("eye.core.util")
local Config = require("eye.core.config")
local Node = require("eye.core.tree.node")
local Leaf = require("eye.core.tree.leaf")

--- @class Eye.Root: Eye.Node
--- @field buffers table<string, Eye._Config>
--- @field config Eye._Config
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
--- @param spec Eye._LabelSpec
--- @param label_base Eye.Config.LabelBase
--- @param parent_config Eye._Config
function M:_build(node, spec, label_base, parent_config)
  local include = self.config.label.misc.include
  if not node then
    return
  end

  local function build(n)
    self:_build(n, spec, label_base, parent_config)
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
    Leaf:new(node, get_random_label(include, node), spec, label_base, #include, parent_config)
  else
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
end

--- @param register Eye.BufferConfig[]
local function compute_label_count(register)
  local total = 0
  for _, r in ipairs(register) do
    total = total + #r.source
  end
  return total
end

--- @param buffer_configs Eye.BufferConfig[]
function M:_register(buffer_configs)
  for _, config in ipairs(buffer_configs) do
    local buffer_config = Config:proxy(Config:normalize(config), self.config)
    self.buffers[tostring(config.buf)] = buffer_config
    for _, label in ipairs(config.source) do
      local spec = {
        buf = config.buf,
        items = label.items,
        data = label.data,
      }
      self:_build(self.current, spec, label --[[@as Eye.Config.LabelBase]], buffer_config)
    end
  end
end

--- @param config Eye.Config
--- @return Eye.Root
function M:new(config)
  local root = Node.new(self) --[[@as Eye.Root]]
  root.config = Config:proxy(Config:normalize(config or {}))
  local level, remain1, remain2 = U.compute(#root.config.label.misc.include, compute_label_count(config.source))
  root.buffers = {}
  root.id = "0"
  root.level = level + 1
  root.remain = remain2 + 1
  root.current = Node:new(root, "[[empty]]", remain1)
  setmetatable(root.children, { __index = root.current.children })
  root:_register(vim.tbl_deep_extend("force", {}, config.source))
  return root
end

function M:start()
  U.try(self.config.hook.start)
  Node.start(self)
end

function M:stop(ctx)
  if not ctx.matched then
    U.try(self.config.hook.unmatched, ctx)
  end
  U.try(self.config.hook.stop, ctx)
end

function M:refresh()
  local Core = require("eye.core")
  for str_buf, _ in pairs(self.buffers) do
    local buf = tonumber(str_buf) --[[@as integer]]
    vim.api.nvim_buf_clear_namespace(buf, Core.ns_id, 0, -1)
  end
end

return M
