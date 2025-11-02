local M = {}
local KEYS = "abcdefghijklmnopqrstuvwxyz"

--- @class EyeTrack.Key.RegisterOptions
--- @field callback fun()
--- @field line number
--- @field virt_col number
--- @field hidden_next_key? boolean | fun():boolean|nil

local function get_leaf_ancestor_list(leaf, root)
  local ancestor_list = {}
  local node = leaf
  while node do
    if node.key then
      table.insert(ancestor_list, 1, node)
    end
    node = node.parent
    if node.ns_id == root.ns_id and node.key == root.key then
      node = nil
    end
  end
  return ancestor_list
end

local function set_extmark(options)
  local line = options.line
  local virt_col = options.virt_col
  local ns_id = options.ns_id
  vim.api.nvim_buf_set_extmark(0, ns_id, line, 0, {
    virt_text_win_col = virt_col,
    virt_text = { { options.text, options.hl_group } },
  })
end

local function highlight_node(leaf, root)
  local ancestor_list = get_leaf_ancestor_list(leaf, root)
  for i, node in ipairs(ancestor_list) do
    if node then
      set_extmark({
        line = leaf.line,
        virt_col = leaf.virt_col + i - 1,
        ns_id = node.parent.ns_id,
        hl_group = i == 1 and "EyeTrackKey" or "EyeTrackNextKey",
        text = node.key,
      })
    end
  end
end

local function highlight_nodes(root)
  local function run(node)
    if node.level == 0 then
      highlight_node(node, root)
      return
    end
    for _, child in pairs(node.keys or {}) do
      run(child)
    end
  end
  run(root)
end

local function get_random_key(node)
  if node.remain == 0 then
    return
  end

  local random = math.random(26)
  local key = KEYS:sub(random, random)
  if node.keys[key] == nil then
    return key
  end

  return get_random_key(node)
end

function M:create_ns_id()
  local ns_id = vim.api.nvim_create_namespace("eye-track-namespace" .. #self.ns_ids)
  table.insert(self.ns_ids, ns_id)
  return ns_id
end

function M:clear_ns_id(opts)
  opts = opts or {}

  if opts.filter_id == nil then
    for _, ns_id in ipairs(self.ns_ids) do
      vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
    end
    return
  end

  for _, ns_id in ipairs(self.ns_ids) do
    if ns_id ~= opts.filter_id then
      vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
    end
  end
end

function M:listen(opts)
  opts = opts or {}
  vim.schedule(function()
    local char = vim.fn.nr2char(vim.fn.getchar() --[[@as integer]])

    if not self.current_keys or self.current_keys[char] == nil then
      self:clear_ns_id()
      return
    end
    self.current_keys[char].callback()
  end)
end

local function compute(total)
  --- @return number, number, number
  local function compute_run(i)
    local min = math.pow(26, i)
    local max = math.pow(26, i + 1)

    if total >= min and total <= max then
      local remain = total - min
      local quotient = math.ceil(remain / min)
      local remainder = remain - (quotient * min)
      local key_count = math.ceil((remainder + quotient) / min) + quotient
      return i, 26 - key_count, key_count
    elseif total > max then
      return compute_run(i + 1)
    end
    return i, total, 0
  end

  return compute_run(1)
end

function M:register_leaf(node, key, callback)
  if not key then
    return
  end

  local child_node = {
    level = 0,
    key = key,
    parent = node,
    callback = function()
      self:clear_ns_id()
      if type(callback) == "function" then
        callback(key)
      end
    end,
  }
  node.keys[key] = child_node
  node.remain = node.remain - 1
  return child_node
end

function M:register_node(node, key)
  if not key then
    return
  end

  local child_node = {
    level = node.level - 1,
    key = key,
    remain = 26,
    keys = {},
    ns_id = self:create_ns_id(),
    parent = node,
  }
  child_node.callback = function()
    self.current_keys = child_node.keys
    self:clear_ns_id()
    highlight_nodes(child_node)
    vim.cmd.redraw()
    self:listen()
  end
  node.keys[key] = child_node
  node.remain = node.remain - 1
  return child_node
end

--- @param options EyeTrack.Key.RegisterOptions
function M:_register(node, options)
  if not node then
    return
  end

  local function transfer()
    if node.parent then
      node.parent.current = nil
      self:_register(node.parent, options)
    end
  end

  if node.level == 1 then
    if node.remain == 0 then
      transfer()
      return
    end
    local leaf = self:register_leaf(node, get_random_key(node), options.callback)
    leaf.line = options.line
    leaf.virt_col = options.virt_col
    leaf.text = leaf.key
  else
    if node.current then
      self:_register(node.current, options)
      return
    end
    if node.remain == 0 then
      transfer()
      return
    end
    node.current = self:register_node(node, get_random_key(node))
    self:_register(node.current, options)
  end
end

--- @param options EyeTrack.Key.RegisterOptions
function M:register(options)
  self:_register(self.root, options)
end

function M:init(total)
  local level, remain1, remain2 = compute(total)
  self.ns_ids = {}
  self.root = {
    level = level + 1,
    remain = remain2 + 1,
    keys = {},
    ns_id = self:create_ns_id(),
  }
  self.root.current = self:register_node(self.root, "_")
  self.root.current.key = nil
  self.root.current.remain = remain1
  self.current_keys = setmetatable(self.root.keys, { __index = self.root.keys["_"].keys })
end

--- @param registers table<EyeTrack.Key.RegisterOptions>
function M:main(registers)
  self:init(#registers + 10)
  for _, value in ipairs(registers) do
    self:register(value)
  end
  highlight_nodes(self.root)
  self:listen()
end

return M
