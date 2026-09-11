local U = require("_eye.core.utils")
local Cfg = require("_eye.core.config")

--- @class _Eye.Active
--- @field actived_node_queue _Eye.Node[]
--- @field actived_leafs _Eye.Leaf[]
--- @field actived_nodes _Eye.Node[]
local M = {}
M.__index = M

--- @class _Eye.Active.Opts
--- @field actived_node_queue _Eye.Node[]
--- @field actived_leafs _Eye.Leaf[]
--- @field actived_nodes _Eye.Node[]
--- @field config _Eye.Active.Config

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
--- @param actived_leafs _Eye.Leaf[]
--- @param actived_nodes _Eye.Node[]
--- @return boolean|nil
local function _is_actived_node(node, actived_leafs, actived_nodes)
  return vim.tbl_contains(actived_nodes, node) or vim.tbl_contains(actived_leafs, node)
end

--- @param node _Eye.Node|_Eye.Leaf|nil
--- @param actived_leafs _Eye.Leaf[]
--- @param actived_nodes _Eye.Node[]
--- @return boolean
local function is_actived_node(node, actived_leafs, actived_nodes)
  if not node then
    return false
  end
  if is_leaf(node) then
    return vim.tbl_contains(actived_leafs, node)
  end
  local children = node.children
  for _, child in pairs(children) do
    if not vim.tbl_contains(actived_leafs, child) and not vim.tbl_contains(actived_nodes, child) then
      return false
    end
  end
  return true
end

--- @param node _Eye.Node
--- @param actived_leafs _Eye.Leaf[]
--- @param actived_nodes _Eye.Node[]
local function get_inactive_nodes(node, actived_leafs, actived_nodes)
  local children = {}
  for key, child in pairs(node.children) do
    if not _is_actived_node(child, actived_leafs, actived_nodes) then
      children[key] = child
    end
  end
  return children
end

--- @param leaf _Eye.Leaf
--- @param actived_leafs _Eye.Leaf[]
--- @param actived_nodes _Eye.Node[]
local function collect_actived_node(leaf, actived_leafs, actived_nodes)
  table.insert(actived_leafs, leaf)
  local function collect(n)
    if is_actived_node(n, actived_leafs, actived_nodes) then
      table.insert(actived_nodes, n)
      collect(n.parent)
    end
  end
  collect(leaf.parent)
end

--- @param root _Eye.Node|_Eye.Leaf
--- @param actived_leafs _Eye.Leaf[]
--- @param actived_nodes _Eye.Node[]
--- @return _Eye.ActiveContext.Entry
local function create_entries(root, actived_leafs, actived_nodes)
  local entries = {}

  --- @param node _Eye.Node|_Eye.Leaf
  --- @param labels string[]
  local function append_entry(node, labels)
    if node.label ~= "[[root]]" and node ~= root then
      labels[#labels + 1] = node.label
    end

    if is_leaf(node) then
      if #labels > 0 then
        table.insert(entries, { data = node.data, labels = labels })
      end
    elseif is_node(node) then
      local inactive_nodes = get_inactive_nodes(node, actived_leafs, actived_nodes)
      for _, child in pairs(inactive_nodes) do
        append_entry(child, vim.tbl_extend("force", labels, {}))
      end
    end
  end
  append_entry(root, {})
  return entries
end

--- @param opts _Eye.Active.Opts
function M:new(opts)
  local o = setmetatable({}, self)
  o.actived_node_queue = opts.actived_node_queue
  o.actived_leafs = opts.actived_leafs
  o.actived_nodes = opts.actived_nodes
  o.config = opts.config
  return o
end
--- @param config? _Eye.Active.Config
--- @return _Eye.Active
function M:active(config)
  config = Cfg.merge_active_config(config or {})
  local queue = self.actived_node_queue
  local actived_leafs = self.actived_leafs
  local actived_nodes = self.actived_nodes
  local node = table.remove(queue, #queue)

  local prev = {}
  local actions = config.actions

  local rollback = function(count)
    count = count or 1
    vim.validate("count", count, "number")
    count = math.min(math.floor(count), 1)
    count = math.min(count, #queue - 1)
    for _ = 1, count do
      table.remove(queue, #queue)
    end
    node = queue[#queue]
  end

  --- @type _Eye.ActionContext
  local action_context = {
    rollback = rollback,
    finish = function(cb)
      node = nil
      prev.done = cb
    end,
  }

  --- @param n _Eye.Node|_Eye.Leaf
  --- @return fun()|nil
  local function actived(n)
    return U.try(config.active, {
      entries = create_entries(n, actived_leafs, actived_nodes),
      active = n.label,
      data = n.data,
      rollback = rollback,
    })
  end

  while node do
    if node ~= prev.node then
      U.try(prev.clean)
    end

    if is_leaf(node) then
      collect_actived_node(node, actived_leafs, actived_nodes)
      local clean = actived(node)
      prev = {
        node = node,
        clean = function()
          U.try(clean)
          return { type = "complete" }
        end,
      }
      node = nil
    else
      if node ~= prev.node then
        table.insert(queue, node)
        local clean = actived(node)
        prev = {
          node = node,
          clean = function()
            U.try(clean)
            return { type = "cancel" }
          end,
        }
      end
      local char = U.get_char()
      local action = actions[char:lower()]
      if action then
        U.try(action, action_context)
      else
        node = node.children[char]
        if _is_actived_node(node, actived_leafs, actived_nodes) then
          node = nil
        end
      end
    end
  end

  local finish_context = U.try(prev.clean)
  if finish_context then
    if finish_context.type == "complete" then
      U.try(config.complete)
    elseif finish_context.type == "cancel" then
      U.try(config.cancel)
    end
    U.try(config.finish, finish_context)
    U.try(prev.done)
  end

  local clone_queue = vim.tbl_extend("force", {}, queue)
  if _is_actived_node(clone_queue[#clone_queue], actived_leafs, actived_nodes) then
    table.remove(clone_queue, #clone_queue)
  end
  return M:new({
    config = config,
    actived_leafs = vim.tbl_extend("force", {}, actived_leafs),
    actived_nodes = vim.tbl_extend("force", {}, actived_nodes),
    actived_node_queue = clone_queue,
  })
end

--- @param config? _Eye.Active.Config
--- @return _Eye.Active
function M:_active(config)
  config = Cfg.merge_active_config(config or {})
  local queue = self.actived_node_queue
  local actived_leafs = self.actived_leafs
  local actived_nodes = self.actived_nodes
  local node = table.remove(queue, #queue)

  local prev = {}
  local actions = config.actions

  local rollback = function(count)
    count = count or 1
    vim.validate("count", count, "number")
    count = math.min(math.floor(count), 1)
    count = math.min(count, #queue - 1)
    for _ = 1, count do
      table.remove(queue, #queue)
    end
    node = queue[#queue]
  end

  --- @type _Eye.ActionContext
  local action_context = {
    rollback = rollback,
    finish = function(cb)
      node = nil
      prev.finish = cb
    end,
  }

  --- @param n _Eye.Node|_Eye.Leaf
  --- @return fun()|nil
  local function actived(n)
    return U.try(config.active, {
      entries = create_entries(n, actived_leafs, actived_nodes),
      active = n.label,
      data = n.data,
      rollback = rollback,
    })
  end

  while node do
    if node ~= prev.node then
      U.try(prev.clean)
      prev = { node = node }

      if is_node(node) then
        table.insert(queue, node)
        local clean = actived(node)
        prev.clean = function()
          U.try(clean)
          return { type = "cancel" }
        end
      elseif is_leaf(node) then
        collect_actived_node(node, actived_leafs, actived_nodes)
        local clean = actived(node)
        prev.clean = function()
          U.try(clean)
          return { type = "complete" }
        end
      end
    else
      if is_node(node) then
        local char = U.get_char()
        local action = actions[char:lower()]
        if action then
          U.try(action, action_context)
        else
          node = node.children[char]
          if _is_actived_node(node, actived_leafs, actived_nodes) then
            node = nil
          end
        end
      elseif is_leaf(node) then
        node = nil
      end
    end
  end

  local finish_context = U.try(prev.clean)
  if finish_context then
    if finish_context.type == "complete" then
      U.try(config.complete)
    elseif finish_context.type == "cancel" then
      U.try(config.cancel)
    end
    U.try(config.finish, finish_context)
    U.try(prev.finish)
  end

  local clone_queue = vim.tbl_extend("force", {}, queue)
  if _is_actived_node(clone_queue[#clone_queue], actived_leafs, actived_nodes) then
    table.remove(clone_queue, #clone_queue)
  end
  return M:new({
    config = config,
    actived_leafs = vim.tbl_extend("force", {}, actived_leafs),
    actived_nodes = vim.tbl_extend("force", {}, actived_nodes),
    actived_node_queue = clone_queue,
  })
end

return M
