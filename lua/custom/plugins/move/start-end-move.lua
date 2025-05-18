local M = {}

local Key = {}
local Line = {}

local Left = {
  key = "^"
}
local Right = {
  key = "g_"
}

local function get_viewport_width(wininfo)
  local viewport_width = wininfo.width - wininfo.textoff
  return viewport_width - 1
end

function Left:get_extmark_col(offset)
  return 0
end

function Right:get_extmark_col(offset)
  local viewport_width = get_viewport_width(self.wininfo)
  if offset then
    return viewport_width + offset
  end

  return viewport_width
end

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


--- @param param table
local function more_key_set_extmark(param)
  vim.api.nvim_buf_set_extmark(0, param.ns_id, param.line, 0, {
    virt_text = param.virt_text,
    virt_text_win_col = param.virt_text_win_col
  })
end

local function one_key_set_extmark(parent, line, Action)
  local keymap = get_keymap(parent)
  keymap.jump_number = line + 1
  vim.api.nvim_buf_set_extmark(0, parent.ns_id, line, 0, {
    virt_text = { { keymap.key, "HopNextKey" } },
    virt_text_win_col = Action:get_extmark_col()
  })
end

function Key:on_key(keymap)
  vim.schedule(function()
    local char = vim.fn.nr2char(vim.fn.getchar())
    local child_keymap = keymap.child[char]
    if child_keymap then
      if child_keymap.callback then
        child_keymap.callback()
      end
      if child_keymap.jump_number then
        vim.api.nvim_feedkeys(child_keymap.jump_number .. "G" .. self.Action.key, "nx", false)
      end
    end
    self:clean_mark()
    Line:del_hl()
  end)
end

local function reset_keymap_mark(keymap)
  keymap.ns_id = vim.api.nvim_create_namespace(keymap.key .. "-custom")
  for key, value in pairs(keymap.child) do
    value.reset_mark()
  end
  vim.cmd.redraw()
end

local function fill_more_keymap(keymap)
  keymap.ns_id = vim.api.nvim_create_namespace(keymap.key .. "-custom")
  keymap.callback = function()
    Key:clean_mark()
    reset_keymap_mark(keymap)
    Key:on_key(keymap)
  end
end

local function fill_one_keymap(keymap, extmark)
  keymap.jump_number = extmark.line + 1
  keymap.reset_mark = function()
    vim.api.nvim_buf_set_extmark(0, extmark.ns_id, extmark.line, 0, {
      virt_text = { { keymap.key, "HopNextKey" } },
      virt_text_win_col = extmark.virt_text_win_col
    })
  end
end

function Key:clean_mark(all)
  vim.api.nvim_buf_clear_namespace(0, self.keymap.ns_id, 0, -1)
  for k, value in pairs(self.keymap.child) do
    if value.ns_id then
      vim.api.nvim_buf_clear_namespace(0, value.ns_id, 0, -1)
    end
  end
end

function Key:init(line_count, LR, wininfo)
  self.keymap = {
    count = 0,
    child = {},
    ns_id = vim.api.nvim_create_namespace("base-custom")
  }
  self.up_break = nil
  self.down_break = nil
  self.more_keymap = {}
  self.keys = "abcdefghijklmnopqrstuvwxyz"
  self:collect_more_keys(line_count)
  if LR == "left" then
    self.Action = Left
  else
    self.Action = Right
  end
  self.Action.wininfo = wininfo
end

function Key:collect_more_keys(line_count)
  local count = 0
  if line_count > 26 then
    count = math.ceil((line_count - 26) / 26)
  end
  for i = 1, count do
    local keymap = get_keymap(self.keymap)
    fill_more_keymap(keymap)
    table.insert(self.more_keymap, keymap)
  end
end

function Key:no_key_can_be_use(cursor_row, count)
  if self.keymap.count == 26 then
    self.up_break = cursor_row - count
    self.down_break = cursor_row + count
  end
end

function Key:one_keys(topline, botline, cursor_row)
  local count = 0

  while true do
    if self.up_break ~= nil and self.down_break ~= nil then
      break
    end

    if not self.up_break then
      if cursor_row - count > topline - 1 then
        one_key_set_extmark(self.keymap, cursor_row - count - 1, self.Action)
        self:no_key_can_be_use(cursor_row, count)
      else
        self.up_break = cursor_row - count
      end
    end

    if not self.down_break then
      if cursor_row + count < botline then
        one_key_set_extmark(self.keymap, cursor_row + count, self.Action)
        self:no_key_can_be_use(cursor_row, count)
      else
        self.down_break = cursor_row + count
      end
    end
    count = count + 1
  end
end

function Key:more_keys(topline, botline)
  if Key.up_break > 1 then
    for i = topline, Key.up_break - 1 do
      local keymap, child_keymap = Key:get_more_key_keymap(i)
      more_key_set_extmark({
        ns_id = keymap.ns_id,
        line = i - 1,
        virt_text = { { keymap.key, "HopNextKey1" }, { child_keymap.key, "HopNextKey2" } },
        virt_text_win_col = self.Action:get_extmark_col(-1)
      })
    end
  end

  if Key.down_break <= botline then
    for i = Key.down_break + 1, botline do
      local keymap, child_keymap = Key:get_more_key_keymap(i)
      more_key_set_extmark({
        ns_id = keymap.ns_id,
        line = i - 1,
        virt_text = { { keymap.key, "HopNextKey1" }, { child_keymap.key, "HopNextKey2" } },
        virt_text_win_col = self.Action:get_extmark_col(-1)
      })
    end
  end
end

function Key:get_more_key_keymap(i)
  local parent = self.more_keymap[1]
  if not parent then
    return {}, {}
  end
  if parent.count == 26 then
    table.remove(self.more_keymap, 1)
  end
  local keymap = get_keymap(parent)
  fill_one_keymap(keymap, {
    ns_id = parent.ns_id,
    line = i - 1,
    virt_text_win_col = self.Action:get_extmark_col()
  })
  return parent, keymap
end

function Line:init(topline, botline)
  self.ns_id = nil
  Line:set_hl(topline, botline)
end

function Line:set_hl(topline, botline)
  self.ns_id = vim.api.nvim_create_namespace("line-custom")
  vim.api.nvim_buf_set_extmark(0, self.ns_id, topline - 1, 0, {
    end_row = botline,
    hl_group = "HopUnmatched"
  })
end

function Line:del_hl()
  vim.api.nvim_buf_clear_namespace(0, self.ns_id, 0, -1)
end

--- @param LR "left"|"right"
function M.start_end_move(LR)
  local count = vim.v.count1

  if LR == "left" then
    if count == 1 then
      local cursor1 = vim.api.nvim_win_get_cursor(0)
      vim.api.nvim_feedkeys("^", "nx", false)
      local cursor2 = vim.api.nvim_win_get_cursor(0)
      if cursor1[2] == cursor2[2] then
        vim.api.nvim_feedkeys("0", "nx", false)
      end
    end
  else
    if count == 1 then
      local cursor1 = vim.api.nvim_win_get_cursor(0)
      vim.api.nvim_feedkeys(count .. "g_", "nx", false)
      local cursor2 = vim.api.nvim_win_get_cursor(0)
      if cursor1[2] == cursor2[2] then
        vim.api.nvim_feedkeys("$", "nx", false)
      end
    end
  end
end

--- @param LR "left" | "right"
function M.start_end_move_general(LR)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_row = cursor[1]
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local topline = wininfo.topline
  local botline = wininfo.botline

  Line:init(topline, botline)
  Key:init(botline - topline + 1, LR, wininfo)
  Key:one_keys(topline, botline, cursor_row)
  Key:more_keys(topline, botline)
  Key:on_key(Key.keymap)
end

return M
