local Cfg = require("_eye.core.config")
local Node = require("_eye.core.node")
local Leaf = require("_eye.core.leaf")
local Active = require("_eye.core.active")

--- @class _Eye.Build.Spec.Get.Context
--- @field origin_include string[]
--- @field include string[]
--- @field exclude string[]
--- @field depth integer

--- @class _Eye.Build.Spec.Share
--- @field get? fun(ctx: _Eye.Build.Spec.Get.Context):string

--- @class _Eye.Build.Queue: _Eye.Build.Spec.Share
--- @field [integer] _Eye.Build.Spec

--- @class _Eye.Config.Build: _Eye.Build.Spec.Share
--- @field [integer] _Eye.Build.Queue

--- @class _Eye.Build.Spec: _Eye.Build.Spec.Share
--- @field include string[]

--- @class _Eye.ActiveContext.Entry
--- @field labels string[]
--- @field data any

--- @class _Eye.ActiveContext
--- @field label string
--- @field entries _Eye.ActiveContext.Entry[]
--- @field data any
--- @field rollback fun(count?: integer)

--- @class _Eye.FinishContext
--- @field type "complete"|"cancel"|"action"

--- @class _Eye.ActionContext
--- @field rollback fun(count?: integer)
--- @field finish fun(cb?: fun())

--- @class _Eye.Config
--- @field build? _Eye.Config.Build|fun(total: integer):_Eye.Config.Build

--- @class _Eye._Label
--- @field root _Eye.Node
--- @field config _Eye.Config

--- @class _Eye.Tree
--- @field private _ _Eye._Label
local M = {}
M.__index = M

--- @param include string[]
--- @param exclude table<string, boolean>
local function get_include(include, exclude)
  local _include = {}
  for _, char in ipairs(include) do
    if not exclude[char] then
      table.insert(_include, char)
    end
  end
  return _include
end

local build_tree

--- @class _Eye.Build.Node
--- @field node _Eye.Node
--- @field parent? _Eye.Build.Node
--- @field include string[]
--- @field exclude table<string, boolean>
--- @field depth integer
--- @field used integer
--- @field get? fun(ctx: any):string

--- @param root _Eye.Node
--- @param specs _Eye.Build.Queue
--- @param labels any[]
function build_tree(root, specs, labels)
  --- @type _Eye.Build.Node
  local node = {
    node = root,
    depth = 1,
    used = 0,
    include = specs[1].include,
    exclude = {},
    get = specs[1].get or specs.get,
  }

  --- @param n _Eye.Build.Node
  local function _build(n)
    if #labels == 0 then
      return
    end

    if n.current then
      _build(n.current)
      return
    end

    if n.used == #n.include then
      if n.parent then
        n.parent.current = nil
        _build(n.parent)
      end
      return
    end

    local next_node
    local next_depth = n.depth + 1
    local next_spec = specs[next_depth]
    local label = n.get({
      origin_include = vim.tbl_deep_extend("force", {}, n.include),
      include = get_include(n.include, n.exclude),
      exclude = vim.tbl_keys(n.exclude),
      depth = n.depth,
    })
    n.exclude[label] = true
    n.used = n.used + 1

    if next_spec == nil then
      Leaf:new({ label = label, parent = n.node, data = table.remove(labels, 1) })
      next_node = n
    else
      n.current = {
        parent = n,
        node = Node:new({ label = label, parent = n.node }),
        depth = next_depth,
        used = 0,
        get = next_spec.get or specs.get,
        include = next_spec.include,
        exclude = {},
      }
      next_node = n.current
    end
    _build(next_node)
  end

  _build(node)
end

--- @param labels any[]
--- @param config? _Eye.Config
--- @return _Eye.Tree
function M:new(labels, config)
  local o = setmetatable({}, self)
  o._ = {
    config = Cfg.merge_label_config(config or {}),
    ---@diagnostic disable-next-line: assign-type-mismatch
    root = nil,
  }
  o:build(labels)
  return o
end

--- @param labels any[]
function M:build(labels)
  labels = vim.tbl_deep_extend("force", labels, {})
  self._.root = Node:new({ label = "[[root]]" })
  self._.root.tree = self
  local builds = type(self._.config.build) == "function" and self._.config.build(#labels) or self._.config.build --[[@as _Eye.Config.Build]]
  for _, specs in ipairs(builds or {}) do
    specs.get = specs.get or builds.get
    build_tree(self._.root, specs, labels)
  end
end

--- @class _Eye.Active.Config
--- @field active? fun(ctx: _Eye.ActiveContext): fun()|nil
--- @field finish? fun(ctx: _Eye.FinishContext)
--- @field complete? fun()
--- @field cancel? fun()
--- @field actions? table<string, fun(api: _Eye.ActionContext)>

--- @param config? _Eye.Active.Config
function M:active(config)
  return Active:new({
    config = config or {},
    actived_leafs = {},
    actived_nodes = {},
    actived_node_queue = { self._.root },
  }):active(config)
end

--- @param config? _Eye.Active.Config
function M:_active(config)
  return Active:new({
    config = config or {},
    actived_leafs = {},
    actived_nodes = {},
    actived_node_queue = { self._.root },
  }):_active(config)
end

return M
