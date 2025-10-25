local M = {}
local KEYS = "abcdefghijklmnopqrstuvwxyz"

--- @class EyeTrack.Key.Visual
--- @field start_col number
--- @field end_col number
--- @field hl_group? string

--- @class EyeTrack.Key.KeyManage
--- @field available_key_count number
--- @field used_key_count number
--- @field keys table
--- @field ns_id number

--- @class EyeTrack.Key.RegisterOptions
--- @field callback fun()
--- @field line number
--- @field virt_col number
--- @field hidden_next_key? boolean | fun():boolean|nil
--- @field visual? EyeTrack.Key.Visual

--- @return EyeTrack.Key.KeyManage
local function create_key_manage()
  return {
    available_key_count = 0,
    used_key_count = 0,
    keys = {},
  }
end

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
  local hidden_next_key = opts.hidden_next_key

  local hl_groups = get_hl_groups(visual)
  vim.api.nvim_buf_set_extmark(0, ns_id1, line, 0, {
    virt_text_win_col = virt_col,
    virt_text = { { key1, hl_groups.CustomMagicNextKey1 } },
  })

  if type(hidden_next_key) == "function" then
    hidden_next_key = hidden_next_key()
  end

  if not hidden_next_key then
    vim.api.nvim_buf_set_extmark(0, ns_id2, line, 0, {
      virt_text_win_col = virt_col + 1,
      virt_text = { { key2, hl_groups.CustomMagicNextKey2 } },
    })
  end
  set_visual_hl(ns_id2, line, visual)
end

local function get_random_key(is_ok)
  local count = 0
  local function run()
    if count == 26 then
      return nil
    end

    count = count + 1

    local random = math.random(26)
    local key = KEYS:sub(random, random)
    if not is_ok(key) then
      return run()
    end

    return key
  end

  return run()
end

--- @return number, number, number
local function compute_run(total, i)
  local min = math.pow(26, i)
  local max = math.pow(26, i + 1)

  if total >= min and total <= max then
    local remain = total - min
    local quotient = math.floor(remain / min)
    local remainder = remain - (quotient * min)
    local key_count = math.ceil((remainder + quotient) / min) + quotient
    return i, 26 - key_count, key_count
  elseif total > max then
    return compute_run(i + 1)
  elseif total < min then
    return i, total, 0
  end

  return 0, 0, 0
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

--- @param opts EyeTrack.Key.RegisterOptions
function M:register_one_key(opts)
  local key = get_random_key(function(key)
    return self.one_key.keys[key] == nil
  end)

  if not key then
    return
  end

  self.one_key.keys[key] = {
    key = key,
    callback = function()
      self:clear_ns_id()
      if type(opts.callback) == "function" then
        opts.callback()
      end
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

--- @param opts EyeTrack.Key.RegisterOptions
function M:register_two_key(opts)
  if self.two_key.current == nil then
    local key = get_random_key(function(key)
      return self.two_key.keys[key] == nil and self.one_key.keys[key] == nil
    end)

    if not key then
      return
    end

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
    M:register_two_key(opts)
  else
    local current = self.two_key.current

    if current.used_key_count == current.available_key_count then
      self.two_key.current = nil
      M:register_two_key(opts)
      return
    end

    local key = get_random_key(function(key)
      return current.keys[key] == nil
    end)

    if not key then
      return
    end

    current.keys[key] = {
      key = key,
      callback = function()
        self:clear_ns_id()
        if type(opts.callback) == "function" then
          opts.callback()
        end
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
      hidden_next_key = opts.hidden_next_key,
    })
  end
end

function M:listen(opts)
  opts = opts or {}
  vim.schedule(function()
    local char = vim.fn.nr2char(vim.fn.getchar() --[[@as integer]])

    if self.on_keys[char] == nil then
      self:clear_ns_id()
      if opts and opts.unmatched_callback then
        opts.unmatched_callback()
      end
      self:clean()
      return
    end

    self.on_keys[char].callback()

    if opts.matched_callback then
      opts.matched_callback()
    end
  end)
end

function M:compute(total)
  local i, key_count1, key_count2 = compute_run(total, 1)
  if i == 1 then
    self.one_key.available_key_count = key_count1
    self.one_key.ns_id = self:create_ns_id("custom-delete-word-one-key")
    self.two_key.available_key_count = key_count2
    return
  end
  if i == 2 then
    self.two_key.available_key_count = key_count1
    self.three_key.available_key_count = key_count2
    return
  end
end

--- @param options EyeTrack.Key.RegisterOptions
function M:register(options)
  if self.one_key.used_key_count < self.one_key.available_key_count then
    self:register_one_key(options)
    return
  end

  if self.two_key.used_key_count < self.two_key.available_key_count then
    self:register_two_key(options)
    return
  end

  if self.three_key.used_key_count < self.three_key.available_key_count then
    self:register_three_key()
    return
  end
end

function M:on_key(opts)
  self.on_keys = vim.tbl_extend("force", {}, self.one_key.keys, self.two_key.keys, self.three_key.keys)
  self:listen(opts)
end

function M:init()
  self.ns_ids = {}
  self.on_keys = nil
  self.one_key = create_key_manage()
  self.two_key = create_key_manage()
  self.three_key = create_key_manage()
end

return M
