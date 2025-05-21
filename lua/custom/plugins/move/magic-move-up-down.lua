local M = {}

--- @alias UD "up" | "down"

local Key = {}
local Line = {}
local Up = setmetatable({}, { __index = Key })
local Down = setmetatable({}, { __index = Key })

-- @param keymap table
local function get_keymap(keymap)
  if keymap.count == 26 then
    return {}
  end

  local random = math.random(26)
  local key = Key.keys:sub(random, random)
  local child = keymap.child

  local map = {
    count = 0,
    key = key,
    child = {}
  }

  if child[key] == nil then
    child[key] = map
    keymap.count = keymap.count + 1
    return map
  else
    return get_keymap(keymap)
  end
end

local function reset_more_key_extmark(keymap)
  keymap.ns_id = vim.api.nvim_create_namespace(keymap.key .. "-custom")
  for key, value in pairs(keymap.child) do
    value.reset_mark()
  end
  vim.cmd.redraw()
end

local function fill_keymap_more_key(keymap)
  keymap.ns_id = vim.api.nvim_create_namespace(keymap.key .. "-custom")
  keymap.callback = function()
    Key:clean_mark()
    reset_more_key_extmark(keymap)
    Key:on_key(keymap)
  end
end

local function fill_keymap_one_key(keymap, extmark)
  keymap.jump_number = extmark.line + 1
  keymap.reset_mark = function()
    vim.api.nvim_buf_set_extmark(0, extmark.ns_id, extmark.line, 0, {
      virt_text = { { keymap.key, "HopNextKey" } },
      virt_text_win_col = extmark.virt_text_win_col
    })
  end
end

local function one_key_set_extmark(parent, line, virt_text_win_col)
  local keymap = get_keymap(parent)
  keymap.jump_number = line + 1
  vim.api.nvim_buf_set_extmark(0, parent.ns_id, line, 0, {
    virt_text = { { keymap.key, "HopNextKey" } },
    virt_text_win_col = virt_text_win_col
  })
end

--- @param param table
local function more_key_set_extmark(param)
  vim.api.nvim_buf_set_extmark(0, param.ns_id, param.line, 0, {
    virt_text = param.virt_text,
    virt_text_win_col = param.virt_text_win_col
  })
end

local function jump_key_target(keymap)
  if not keymap then return end

  if keymap.callback then
    keymap.callback()
  end

  if keymap.jump_number then
    vim.api.nvim_feedkeys(keymap.jump_number .. "G", "nx", false)
  end
end

function Up:init()
  self.up_break = nil
end

function Down:init()
  self.down_break = nil
end

function Up:get_line_count()
  return
end

function Down:get_line_count()

end

function Up:one_keys(cursor_row)
  local count = 0

  while true do
    if self.up_break ~= nil then
      break
    end

    if not self.up_break then
      if cursor_row - count > self.topline then
        one_key_set_extmark(self.keymap, cursor_row - count - 1 - 1, self.virt_col)
        if self.keymap.count == 26 then
          self.up_break = cursor_row - count
        end
      else
        self.up_break = cursor_row - count
      end
    end

    count = count + 1
  end
end

function Down:one_keys(cursor_row)
  local count = 0

  while true do
    if self.down_break ~= nil then
      break
    end

    if not self.down_break then
      if cursor_row + count < self.botline then
        one_key_set_extmark(self.keymap, cursor_row + count, self.virt_col)
        if self.keymap.count == 26 then
          self.down_break = cursor_row + count
        end
      else
        self.down_break = cursor_row + count
      end
    end
    count = count + 1
  end
end

function Up:more_keys()
  if self.up_break > 2 then
    for i = self.topline, self.up_break - 2 do
      local keymap, child_keymap = self:get_more_key_keymap(i)
      more_key_set_extmark({
        ns_id = keymap.ns_id,
        line = i - 1,
        virt_text = { { keymap.key, "HopNextKey1" }, { child_keymap.key, "HopNextKey2" } },
        virt_text_win_col = self.virt_col
      })
    end
  end
end

function Down:more_keys()
  if self.down_break <= self.botline then
    for i = self.down_break + 2, self.botline do
      local keymap, child_keymap = self:get_more_key_keymap(i)
      more_key_set_extmark({
        ns_id = keymap.ns_id,
        line = i - 1,
        virt_text = { { keymap.key, "HopNextKey1" }, { child_keymap.key, "HopNextKey2" } },
        virt_text_win_col = self.virt_col
      })
    end
  end
end

function Line:init()
  self.ns_id = nil
  Line:set_hl(Key.topline, Key.botline)
end

function Line:set_hl(topline, botline)
  self.ns_id = vim.api.nvim_create_namespace("line-custom---")
  vim.api.nvim_buf_set_extmark(0, self.ns_id, topline - 1, 0, {
    end_row = botline,
    hl_group = "HopUnmatched"
  })
end

function Line:del_hl()
  vim.api.nvim_buf_clear_namespace(0, self.ns_id, 0, -1)
end

--- @param UD UD
function Key:init(UD, topline, botline, cursor_row, virt_col)
  self.keys = "abcdefghijklmnopqrstuvwxyz"
  self.keymap = {
    count = 0,
    child = {},
    ns_id = vim.api.nvim_create_namespace("base-custom")
  }
  self.more_keymap = {}
  self.virt_col = virt_col

  if UD == "up" then
    self.topline = topline
    self.botline = cursor_row - 1
    self.Action = Up
  else
    self.topline = cursor_row + 1
    self.botline = botline
    self.Action = Down
  end

  self.Action:init()
  self:collect_more_keys()
end

function Key:get_more_key_keymap(i)
  local parent = self.more_keymap[1]
  local keymap = get_keymap(parent)

  if parent.count == 26 then
    table.remove(self.more_keymap, 1)
  end
  fill_keymap_one_key(keymap, {
    ns_id = parent.ns_id,
    line = i - 1,
    virt_text_win_col = self.virt_col
  })
  return parent, keymap
end

function Key:collect_more_keys()
  local count = 0
  local line_count = self.botline - self.topline + 1
  if line_count > 26 then
    count = math.ceil((line_count - 26) / 26)
  end
  for i = 1, count do
    local keymap = get_keymap(self.keymap)
    fill_keymap_more_key(keymap)
    table.insert(self.more_keymap, keymap)
  end
end

function Key:on_key(keymap)
  vim.schedule(function()
    local char = vim.fn.nr2char(vim.fn.getchar())
    jump_key_target(keymap.child[char])
    self:clean_mark()
    Line:del_hl()
  end)
end

function Key:clean_mark()
  vim.api.nvim_buf_clear_namespace(0, self.keymap.ns_id, 0, -1)

  for k, value in pairs(self.keymap.child) do
    if value.ns_id then
      vim.api.nvim_buf_clear_namespace(0, value.ns_id, 0, -1)
    end
  end
end

--- @param UD UD
function M.move_up_down(UD)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_row = cursor[1]
  local virt_col = vim.fn.virtcol(".")
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local topline = wininfo.topline
  local botline = wininfo.botline

  Key:init(UD, topline, botline, cursor_row, virt_col - 1)
  Line:init()
  Key.Action:one_keys(cursor_row)
  Key.Action:more_keys()
  Key:on_key(Key.keymap)
end

return M
