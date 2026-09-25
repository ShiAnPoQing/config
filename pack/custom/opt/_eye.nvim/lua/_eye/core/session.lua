local U = require("_eye.core.utils")
local ACTION = "action"
local ACTIVE = "active"
local CANCEL = "cancel"
local COMPLETE = "complete"
local INPUT = "input"

--- @class _Eye.Session.Event
--- @field type "active"|"action"|"cancel"|"complete"|"input"
--- @field data? any

--- @class _Eye.Session.Current
--- @field node _Eye.Leaf|_Eye.Node|nil
--- @field cleanups fun()[]

--- @class _Eye.Session.State
--- @field queue _Eye.Node[]
--- @field activated_nodes _Eye.Node[]
--- @field activated_leafs _Eye.Leaf[]
--- @field current _Eye.Session.Current

--- @class _Eye.Session.Run.Opts
--- @field active? fun(ctx: _Eye.ActiveContext): fun()|nil
--- @field update? fun(ctx: _Eye.UpdateContext): fun()|nil
--- @field flush? fun()
--- @field press? fun(ctx: _Eye.PressContext)
--- @field complete? fun(ctx: _Eye.ActiveContext): nil|boolean
--- @field cancel? fun()
--- @field actions? table<string, fun(api: _Eye.ActionContext)>

--- @class _Eye.Session
--- @field current _Eye.Session.Current
--- @field queue _Eye.Node[]
--- @field handlers any
--- @field events _Eye.Session.Event[]
--- @field activated_nodes _Eye.Node[]
--- @field activated_leafs _Eye.Leaf[]
local M = {}
M.__index = M

--- @param state _Eye.Session.State
local function new(state)
  return setmetatable({
    current = state.current,
    queue = state.queue,
    events = {},
    activated_leafs = state.activated_leafs,
    activated_nodes = state.activated_nodes,
  }, M)
end

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

--- @param node _Eye.Node|_Eye.Leaf|nil
--- @param activated_leafs _Eye.Leaf[]
--- @param activated_nodes _Eye.Node[]
--- @return boolean|nil
local function is_actived_node(node, activated_leafs, activated_nodes)
  return vim.tbl_contains(activated_nodes, node) or vim.tbl_contains(activated_leafs, node)
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

--- @param leaf _Eye.Leaf
--- @param activated_leafs _Eye.Leaf[]
--- @param activated_nodes _Eye.Node[]
local function collect_actived_node(leaf, activated_leafs, activated_nodes)
  table.insert(activated_leafs, leaf)
  --- @param node _Eye.Node|_Eye.Leaf|nil
  --- @return boolean
  local function evaluate_actived_node(node)
    if not node then
      return false
    end
    if is_leaf(node) then
      return vim.tbl_contains(activated_leafs, node)
    end
    local children = node.children
    for _, child in pairs(children) do
      if not vim.tbl_contains(activated_leafs, child) and not vim.tbl_contains(activated_nodes, child) then
        return false
      end
    end
    return true
  end

  --- @param n _Eye.Node
  local function collect(n)
    if evaluate_actived_node(n) then
      table.insert(activated_nodes, n)
      collect(n.parent)
    end
  end
  collect(leaf.parent)
end

function M:has_event()
  return #self.events ~= 0
end

--- @param ... _Eye.Session.Event[]
function M:push_event(...)
  table.insert(self.events, ...)
end

function M:pop_event()
  return table.remove(self.events, #self.events)
end

function M:clear_events()
  self.events = {}
end

function M:leave_current()
  for _, cleanup in ipairs(self.current.cleanups or {}) do
    U.try(cleanup)
  end
end

--- @param opts _Eye.Session.Run.Opts
function M:init_handlers(opts)
  self.handlers = vim.tbl_extend("force", opts, {
    cancel = function()
      U.try(opts.cancel)
    end,
    complete = function()
      local leaf = self.current.node
      local should_remove = U.try(opts.complete, {
        data = leaf.data,
        labels = { leaf.label },
        rollback = function(count)
          self:rollback(count)
          self:push_event({ type = ACTIVE })
        end,
      })
      if should_remove then
        collect_actived_node(leaf --[[@as _Eye.Leaf]], self.activated_leafs, self.activated_nodes)
      end
    end,
    active = function()
      local node = self.current.node
      local cleanup = U.try(opts.active, {
        label = node.label,
        data = node.data,
        rollback = function(count)
          self:rollback(count)
        end,
      })
      table.insert(self.current.cleanups, cleanup)
    end,
    update = function()
      for _, info in ipairs(get_leafs(self.current.node)) do
        local leaf = info.leaf
        local cleanup = U.try(opts.update, { data = leaf.data, labels = info.labels })
        table.insert(self.current.cleanups, cleanup)
      end
    end,
  })
end

function M:input()
  local current = self.current
  local char = U.get_char()
  if current.node.children[char] then
    self:leave_current()
    --- @type _Eye.Leaf|_Eye.Node|nil
    local next_node = current.node.children[char]
    if is_actived_node(next_node, self.activated_leafs, self.activated_nodes) then
      next_node = nil
    end
    self.current = { node = next_node, cleanups = {} }
    if is_node(next_node) then
      table.insert(self.queue, next_node)
    end
    self:push_event({ type = ACTIVE })
    return
  end
  local l_char = char:lower()
  if self.handlers.actions[l_char] then
    self:push_event({ type = ACTION, data = { action = l_char } })
    return
  end
  self:push_event({ type = CANCEL })
end

function M:action(data)
  local request = {
    rollback = 0,
  }

  U.try(self.handlers.actions[data.action], {
    rollback = function(count)
      request.rollback = request.rollback + count
    end,
    cancel = function()
      request.cancel = true
    end,
  })
  if request.rollback > 0 then
    self:rollback(request.rollback)
    self:push_event({ type = ACTIVE })
    return
  end

  if request.cancel then
    self:push_event({ type = CANCEL })
  else
    self:push_event({ type = INPUT })
  end
end

--- @param count integer
function M:rollback(count)
  if is_leaf(self.current.node) then
    count = count - 1
  end
  local index = math.max(1, #self.queue - count)
  self:leave_current()
  for i = #self.queue, index + 1, -1 do
    table.remove(self.queue, i)
  end
  self.current = { node = self.queue[index], cleanups = {} }
end

function M:active()
  local node = self.current.node
  U.try(self.handlers.active)
  if is_node(node) then
    U.try(self.handlers.update)
    U.try(self.handlers.flush)
    self:push_event({ type = INPUT })
  elseif is_leaf(node) then
    self:push_event({ type = COMPLETE })
  end
end

function M:complete()
  U.try(self.handlers.complete)
  self:leave_current()
  self:clear_events()
end

function M:cancel()
  U.try(self.handlers.cancel)
  self:leave_current()
  self:clear_events()
end

--- @return _Eye.Session.State
function M:snapshot()
  return {
    current = { node = self.current.node, cleanups = {} },
    queue = vim.list_slice(self.queue),
    activated_leafs = vim.tbl_extend("force", {}, self.activated_leafs),
    activated_nodes = vim.tbl_extend("force", {}, self.activated_nodes),
  } --[[@as _Eye.Session.State]]
end

--- @param state _Eye.Session.State
--- @param opts _Eye.Session.Run.Opts
function M.run(state, opts)
  local self = new(state)
  self:init_handlers(opts)
  self:push_event({ type = ACTIVE })
  while self:has_event() do
    local event = self:pop_event()
    if event.type == ACTIVE then
      self:active()
    elseif event.type == CANCEL then
      self:cancel()
    elseif event.type == COMPLETE then
      self:complete()
    elseif event.type == ACTION then
      self:action(event.data)
    elseif event.type == INPUT then
      self:input()
    end
  end
  return self:snapshot()
end

return M

-- --- @param node _Eye.Node
-- --- @param activated_leafs _Eye.Leaf[]
-- --- @param activated_nodes _Eye.Node[]
-- local function get_inactive_nodes(node, activated_leafs, activated_nodes)
--   local children = {}
--   for key, child in pairs(node.children) do
--     if not is_actived_node(child, activated_leafs, activated_nodes) then
--       children[key] = child
--     end
--   end
--   return children
-- end

-- --- @param config? _Eye.Active.Config
-- --- @return _Eye.Active
-- function M:active(config)
--   config = Cfg.merge_active_config(config or {})
--   local queue = vim.tbl_extend("force", {}, self.actived_node_queue)
--   local activated_leafs = self.activated_leafs
--   local activated_nodes = self.activated_nodes
--   local node = table.remove(queue, #queue)
--
--   local prev = {}
--   local actions = config.actions
--
--   local rollback = function(count)
--     count = count or 1
--     vim.validate("count", count, "number")
--     count = math.min(math.floor(count), 1)
--     count = math.min(count, #queue - 1)
--     for _ = 1, count do
--       table.remove(queue, #queue)
--     end
--     node = queue[#queue]
--   end
--
--   --- @type _Eye.ActionContext
--   local action_context = {
--     rollback = rollback,
--   }
--
--   --- @param n _Eye.Node
--   --- @return fun()
--   local function update(n)
--     local cleans = {}
--     for _, leaf_info in ipairs(get_leafs(n)) do
--       local leaf = leaf_info.leaf
--       local clean = U.try(config.update, { data = leaf.data, labels = leaf_info.labels })
--       table.insert(cleans, clean)
--     end
--     U.try(config.flush)
--     return function()
--       for _, cb in ipairs(cleans) do
--         U.try(cb)
--       end
--     end
--   end
--
--   --- @param leaf _Eye.Leaf
--   local function complete(leaf)
--     return U.try(config.complete, { data = leaf.data, labels = { leaf.label }, rollback = rollback })
--   end
--
--   --- @param n _Eye.Node|_Eye.Leaf
--   local function active(n)
--     return U.try(config.active, { label = n.label, data = n.data })
--   end
--
--   local cleans = {}
--   while node do
--     if node ~= prev.node then
--       table.insert(cleans, prev.clean)
--       prev = { node = node }
--       local active_clean = active(node)
--       if is_node(node) then
--         table.insert(queue, node)
--         local update_clean = update(node)
--         prev.clean = function()
--           U.try(update_clean)
--           U.try(active_clean)
--           return CANCEL
--         end
--       elseif is_leaf(node) then
--         local remove = complete(node)
--         if remove then
--           collect_actived_node(node, activated_leafs, activated_nodes)
--         end
--         prev.clean = function()
--           U.try(active_clean)
--           return COMPLETE
--         end
--       end
--     else
--       if is_node(node) then
--         local char = U.get_char()
--         U.try(config.press, { char = char })
--         local action = actions[char:lower()]
--         if action then
--           U.try(action, action_context)
--         else
--           node = node.children[char]
--           if is_actived_node(node, activated_leafs, activated_nodes) then
--             node = nil
--           end
--         end
--       elseif is_leaf(node) then
--         node = nil
--       end
--     end
--     for _, clean in ipairs(cleans) do
--       clean()
--     end
--     cleans = {}
--   end
--
--   local state = U.try(prev.clean)
--   if state == CANCEL then
--     U.try(config.cancel, state)
--   end
--
--   local clone_queue = vim.tbl_extend("force", {}, queue)
--   if is_actived_node(clone_queue[#clone_queue], activated_leafs, activated_nodes) then
--     table.remove(clone_queue, #clone_queue)
--   end
--
--   ---@diagnostic disable-next-line: missing-fields
--   return M:new({
--     config = config,
--     activated_leafs = vim.tbl_extend("force", {}, activated_leafs),
--     activated_nodes = vim.tbl_extend("force", {}, activated_nodes),
--     actived_node_queue = clone_queue,
--   })
-- end
