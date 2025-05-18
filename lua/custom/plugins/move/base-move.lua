local M = {}

--- @alias UD "up" | "down"

local Key = {}
local Line = {}
local Up = {}
local Down = {}

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

local function one_key_set_extmark(parent, line, virt_text_win_col)
  local keymap = get_keymap(parent)
  keymap.jump_number = line + 1
  vim.api.nvim_buf_set_extmark(0, parent.ns_id, line, 0, {
    virt_text = { { keymap.key, "HopNextKey" } },
    virt_text_win_col = virt_text_win_col
  })
end

function Line:init()

end

function Line:set_hl()

end

function Line:del_hl()

end

--- @param UD UD
function Key:init(UD)
  self.keys = "abcdefghijklmnopqrstuvwxyz"

  self.up_break = nil
  self.down_break = nil
  self.more_keymap = {}

  if UD == "up" then
    self.Action = Up
  else
    self.Action = Down
  end
end

function Key:one_keys(topline, botline, cursor_row, cursor_col)
  local count = 0

  while true do
    if self.up_break ~= nil and self.down_break ~= nil then
      break
    end

    if not self.up_break then
      if cursor_row - count > topline - 1 then
        one_key_set_extmark(self.keymap, cursor_row - count - 1, cursor_col)
        self:no_key_can_be_use(cursor_row, count)
      else
        self.up_break = cursor_row - count
      end
    end

    if not self.down_break then
      if cursor_row + count < botline then
        one_key_set_extmark(self.keymap, cursor_row + count, cursor_col)
        self:no_key_can_be_use(cursor_row, count)
      else
        self.down_break = cursor_row + count
      end
    end
    count = count + 1
  end
end

function Key:more_keys()

end

function Key:on_key()
end

--- @param UD UD
function M.magic_up_down(UD)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_row = cursor[1]
  local cursor_col = cursor[2]
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local topline = wininfo.topline
  local botline = wininfo.botline

  Key:init(UD)
  Line:init()
  Key:one_keys(topline, botline, cursor_row, cursor_col)
  Key:more_keys()
  Key:on_key()
end

return M
