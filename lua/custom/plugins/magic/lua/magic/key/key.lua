local M = {}
local KEYS = "abcdefghijklmnopqrstuvwxyz"
local key_types = { "one_key", "two_key", "three_key" }

--- @class VisualExtmarkOpts
--- @field start_col number
--- @field end_col number
--- @field hl_group? string

--- @class KeyHighlightOpts
--- @field visual? VisualExtmarkOpts

--- @class OneKeyRegisterOpts
--- @field line number
--- @field virt_col number
--- @field visual? VisualExtmarkOpts

--- @class TwoKeyRegisterOpts
--- @field line number
--- @field virt_col number
--- @field visual? VisualExtmarkOpts

--- @class KeyRegisterOpts
--- @field one_key OneKeyRegisterOpts
--- @field two_key TwoKeyRegisterOpts
--- @field callback fun()

--- @class KeyOpts

--- @param ns_id number
--- @param line number
--- @param visual VisualExtmarkOpts|nil
local function set_visual_hl(ns_id, line, visual)
  if not visual then
    return
  end
  vim.api.nvim_buf_set_extmark(0, ns_id, line, visual.start_col, {
    end_col = visual.end_col,
    hl_group = visual.hl_group or "Visual",
  })
end

local function get_hl_groups(visual)
  local v = "InVisual"
  local hl_groups = {
    CustomMagicNextKey = "CustomMagicNextKey",
    CustomMagicNextKey1 = "CustomMagicNextKey1",
    CustomMagicNextKey2 = "CustomMagicNextKey2",
  }
  if visual then
    for key, value in pairs(hl_groups) do
      hl_groups[key] = value .. v
    end
  end
  return hl_groups
end

local function set_one_key_extmark(opts)
  local visual = opts.visual
  local line = opts.line
  local virt_col = opts.virt_col
  local ns_id = opts.ns_id
  local key = opts.key

  local hl_groups = get_hl_groups(visual)
  vim.api.nvim_buf_set_extmark(0, ns_id, line, 0, {
    virt_text_win_col = virt_col,
    virt_text = { { key, hl_groups.CustomMagicNextKey } },
  })
  set_visual_hl(ns_id, line, visual)
end

local function set_two_key_extmark(opts)
  local visual = opts.visual
  local ns_id1 = opts.ns_id1
  local ns_id2 = opts.ns_id2
  local key1 = opts.key1
  local key2 = opts.key2
  local line = opts.line
  local virt_col = opts.virt_col

  local hl_groups = get_hl_groups(visual)
  vim.api.nvim_buf_set_extmark(0, ns_id1, line, 0, {
    virt_text_win_col = virt_col,
    virt_text = { { key1, hl_groups.CustomMagicNextKey1 } },
  })
  -- if end_col - start_col ~= 1 then
  vim.api.nvim_buf_set_extmark(0, ns_id2, line, 0, {
    virt_text_win_col = virt_col + 1,
    virt_text = { { key2, hl_groups.CustomMagicNextKey2 } },
  })
  -- end
  set_visual_hl(ns_id2, line, visual)
end

local count = 0
local function get_random_key(is_ok)
  local random = math.random(26)
  local key = KEYS:sub(random, random)

  if not is_ok(key) then
    return get_random_key(is_ok)
  end

  return key
end

function M:compute(total)
  local function run(i)
    if count >= 4 then
      return
    end
    count = count + 1
    local min = math.pow(26, i)
    local max = math.pow(26, i + 1)

    if total >= min and total <= max then
      local remain = total - min
      local quotient = math.floor(remain / min)
      local remainder = remain - (quotient * min)
      local more_keys = math.ceil((remainder + quotient) / min) + quotient
      return {
        [key_types[i]] = 26 - more_keys,
        [key_types[i + 1]] = more_keys,
      }
    elseif total > max then
      return run(i + 1)
    elseif total < min then
      return {
        one_key = total,
        two_key = 0,
      }
    end
  end

  local result = run(1)

  -- print(total)
  if result == nil then
    -- print(total, "chucuo")
    return
  end

  if result.one_key ~= nil then
    self.one_key.available_key_count = result.one_key
    self.one_key.ns_id = self:create_ns_id("custom-delete-word-one-key")
  end
  if result.two_key ~= nil then
    self.two_key.available_key_count = result.two_key
  end
  if result.three_key ~= nil then
    self.three_key.available_key_count = result.three_key
  end
end

--- @param opts KeyRegisterOpts
function M:register(opts)
  if self.one_key.used_key_count < self.one_key.available_key_count then
    self:register_one_key(opts.one_key, opts.callback)
    return
  end

  if self.two_key.used_key_count < self.two_key.available_key_count then
    self:register_two_key(opts.two_key, opts.callback)
    return
  end

  if self.three_key.used_key_count < self.three_key.available_key_count then
    self:register_three_key()
    return
  end
end

--- @param opts OneKeyRegisterOpts
function M:register_one_key(opts, callback)
  local key = get_random_key(function(key)
    return self.one_key.keys[key] == nil
  end)
  self.one_key.keys[key] = {
    key = key,
    callback = function()
      self:clear_ns_id()
      callback()
      self:clean()
    end,
  }
  self.one_key.used_key_count = self.one_key.used_key_count + 1
  set_one_key_extmark({
    visual = opts.visual,
    line = opts.line,
    virt_col = opts.virt_col,
    ns_id = self.one_key.ns_id,
    key = key,
  })
end

--- @param opts TwoKeyRegisterOpts
function M:register_two_key(opts, callback)
  if self.two_key.current == nil then
    local key = get_random_key(function(key)
      return self.two_key.keys[key] == nil and self.one_key.keys[key] == nil
    end)

    local current = {
      available_key_count = 26,
      used_key_count = 0,
      keys = {},
      key = key,
      ns_id = self:create_ns_id("custom-delete-word-two-key-" .. key),
      child_ns_id = self:create_ns_id("custom-delete-word-two-key-" .. key .. "-child"),
    }
    current.callback = function()
      self.on_keys = current.keys
      self:clear_ns_id()
      for _, child in pairs(current.keys) do
        child.reset_mark()
      end
      vim.cmd.redraw()
      self:listen()
    end

    self.two_key.keys[key] = current
    self.two_key.current = current
    M:register_two_key(opts, callback)
  else
    local current = self.two_key.current

    if current.used_key_count == current.available_key_count then
      self.two_key.current = nil
      M:register_two_key(opts, callback)
      return
    end

    local key = get_random_key(function(key)
      return current.keys[key] == nil
    end)
    current.keys[key] = {
      key = key,
      callback = function()
        self:clear_ns_id()
        callback()
        self:clean()
      end,
      reset_mark = function()
        set_one_key_extmark({
          visual = opts.visual,
          line = opts.line,
          virt_col = opts.virt_col,
          ns_id = current.child_ns_id,
          key = key,
        })
      end,
    }
    current.used_key_count = current.used_key_count + 1

    set_two_key_extmark({
      visual = opts.visual,
      ns_id1 = current.ns_id,
      ns_id2 = current.child_ns_id,
      key1 = current.key,
      key2 = key,
      line = opts.line,
      virt_col = opts.virt_col,
    })
  end
end

function M:register_three_key(opts) end

--- @param opts OnKeyOpts
function M:listen(opts)
  vim.schedule(function()
    local char = vim.fn.nr2char(vim.fn.getchar())
    if self.on_keys[char] == nil then
      self:clear_ns_id()
      if opts and opts.unmatched_callback then
        opts.unmatched_callback()
      end
      self:clean()
      return
    end
    self.on_keys[char].callback()

    if opts and opts.matched_callback then
      opts.matched_callback()
    end
  end)
end

--- @class OnKeyOpts
--- @field unmatched_callback? fun()
--- @field matched_callback? fun()

--- @param opts OnKeyOpts
function M:on_key(opts)
  self.on_keys = vim.tbl_extend("force", {}, self.one_key.keys, self.two_key.keys, self.three_key.keys)
  self:listen(opts)
end

function M:create_ns_id(name)
  local ns_id = vim.api.nvim_create_namespace(name)
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

function M:clean()
  for key, value in pairs(self) do
    if type(value) ~= "function" then
      self[key] = nil
    end
  end
  count = 0
end

--- @param opts KeyOpts
function M:init(opts)
  self.ns_ids = {}
  self.on_keys = nil
  self.one_key = {
    available_key_count = 0,
    used_key_count = 0,
    keys = {},
    ns_id = nil,
  }
  self.two_key = {
    available_key_count = 0,
    used_key_count = 0,
    keys = {},
  }
  self.three_key = {
    available_key_count = 0,
    used_key_count = 0,
    keys = {},
  }
end

return M
