local U = require("_eye.core.utils")

--- @class _Eye._Session.Current
--- @field node _Eye.Node|_Eye.Leaf
--- @field cleanups fun()[]

--- @class _Eye._Session
--- @field queue _Eye.Node[]
--- @field _current _Eye._Session.Current
local M = {}
M.__index = M

--- @param node _Eye.Node|_Eye.Leaf|nil
--- @return boolean|nil
local function is_leaf(node)
  return node and node.type == "leaf"
end

--- @param node _Eye.Node|_Eye.Leaf|nil
local function is_node(node)
  return node and node.type == "node"
end

--- @param node _Eye.Node|_Eye.Leaf|nil
local function is_root(node)
  return node and node.type == "node" and node.label == "[[root]]"
end

local function get_leafs(node)
  local leafs = {}
  --- @param n _Eye.Node|_Eye.Leaf
  --- @param labels string[]
  local function iter(n, labels)
    labels = vim.tbl_extend("force", {}, labels)
    if not is_root(n) and n ~= node then
      table.insert(labels, n.label)
    end
    if is_leaf(n) then
      table.insert(leafs, { leaf = n, labels = labels })
    else
      for _, child in pairs(n.children) do
        iter(child, labels)
      end
    end
  end
  iter(node, {})
  return leafs
end

local function new()
  return setmetatable({
    queue = {},
    _current = {
      cleanups = {},
    },
  } --[[@as _Eye._Session]], M)
end

--- @class _Eye._Session.Run.Opts
--- @field active? fun(ctx: _Eye.ActiveContext): fun()|nil
--- @field update? fun(ctx: _Eye.UpdateContext): fun()|nil
--- @field flush? fun()
--- @field press? fun(ctx: _Eye.PressContext)
--- @field complete? fun(ctx: _Eye.ActiveContext): nil|boolean
--- @field cancel? fun()
--- @field actions? table<string, fun(api: _Eye.ActionContext)>

--- @param opts _Eye._Session.Run.Opts
function M.run(opts)
  local self = new()

  --- @param node _Eye.Node|_Eye.Leaf
  local function active(node)
    local cleanup = U.try(nil, {
      label = node.label,
      data = node.data,
      rollback = function(count)
        self:rollback(count)
      end,
    })
    return cleanup
  end

  --- @param node _Eye.Node
  local function update(node)
    local cleanups = {}
    for _, info in ipairs(get_leafs(node)) do
      local leaf = info.leaf
      local cleanup = U.try(opts.update, { data = leaf.data, labels = info.labels })
      table.insert(cleanups, cleanup)
    end
    return function()
      for _, cleanup in ipairs(cleanups) do
        cleanup()
      end
    end
  end

  --- @param node _Eye.Node
  local function node_request(node)
    local char = U.get_char()
    if node.children[char] then
      self:request_transition(node.children[char])
    elseif opts.actions[char:lower()] then
      self:request_transition(node)
      U.try(opts.actions[char:lower()], {
        rollback = function(count)
          self:request_transition(nil)
        end,
      })
    end
  end

  while not self:finish() do
    local current = self:current()
    local node = current.node
    local active_cleanup = active(node)
    table.insert(current.cleanups, active_cleanup)
    if is_node(node) then
      local update_cleanup = update(node)
      table.insert(current.cleanups, update_cleanup)
      U.try(opts.flush)
      node_request(node)
    elseif is_leaf(node) then
      U.try(opts.complete)
      -- node_request(node)
    end
    self:transition()
  end
end

function M:current()
  return self._current
end

--- @param node _Eye.Node|_Eye.Leaf
function M:request_transition(node) end

function M:transition() end

--- @param count integer
function M:rollback(count) end

function M:finish()
  return self._current.node == nil
end

return M
