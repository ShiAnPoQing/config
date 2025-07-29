local M = {}
local KEYS = "abcdefghijklmnopqrstuvwxyz"
local Key = {}
local Line = {}

local function get_keymap(keymap)
  if keymap.count == 26 then
    return
  end

  local random = math.random(26)
  local key = KEYS:sub(random, random)
  local child = keymap.child
  local map = {
    count = 0,
    key = key,
    child = {},
  }

  if child[key] == nil then
    child[key] = map
    keymap.count = keymap.count + 1
    return map
  else
    return get_keymap(keymap)
  end
end

function Line:init(topline, botline)
  self.ns_id = nil
  Line:set_hl(topline, botline)
end

function Line:set_hl(topline, botline)
  self.ns_id = vim.api.nvim_create_namespace("line-custom")
  vim.api.nvim_buf_set_extmark(0, self.ns_id, topline - 1, 0, {
    end_row = botline,
    hl_group = "HopUnmatched",
  })
end

function Line:del_hl()
  vim.api.nvim_buf_clear_namespace(0, self.ns_id, 0, -1)
end

function Key:init(opt)
  self.keymap = {
    count = 0,
    child = {},
    ns_id = vim.api.nvim_create_namespace("test"),
  }
  self.up_break = nil
  self.down_break = nil
  self.left_break = nil
  self.right_break = nil
  self.two_key_list = {}
  self.topline = opt.topline
  self.botline = opt.botline
  self.rightcol = opt.rightcol
  self.center_line = opt.center_line
  self.cursor_virt_win_col = opt.cursor_virt_win_col
  self.leftcol = opt.leftcol
end

local function reset_keymap_mark(keymap)
  keymap.ns_id = vim.api.nvim_create_namespace(keymap.key .. "-custom")
  for key, value in pairs(keymap.child) do
    value.reset_mark()
  end
  vim.cmd.redraw()
end

function Key:collect_two_keys()
  local line_count = self.botline - self.topline + 1
  local two_keys = math.ceil((line_count + self.rightcol - 1 - 26) / 26)

  if (line_count + self.rightcol - 1 - 26) % 26 == 0 then
    two_keys = two_keys + 1
  end

  for i = 1, two_keys do
    local keymap = get_keymap(self.keymap)
    keymap.ns_id = vim.api.nvim_create_namespace(keymap.key .. "-custom")
    keymap.callback = function()
      self:clean_mark()
      reset_keymap_mark(keymap)
      self:on_key(keymap)
    end
    table.insert(self.two_key_list, keymap)
  end
end

function Key:keys_exhaustion(count)
  if self.keymap.count == 26 then
    self.up_break = self.center_line - count
    self.down_break = self.center_line + count
    self.left_break = self.cursor_virt_win_col - count
    self.right_break = self.cursor_virt_win_col + count
  end
end

function Key:one_key_set_extmark(line, virt_text_win_col, count, keymap_opt)
  local _keymap = get_keymap(self.keymap)
  _keymap.target_key = keymap_opt.target_key
  vim.api.nvim_buf_set_extmark(0, self.keymap.ns_id, line, 0, {
    virt_text = { { _keymap.key, "HopNextKey" } },
    virt_text_win_col = virt_text_win_col,
  })
  Key:keys_exhaustion(count)
end

function Key:one_key()
  local count = 0
  while true do
    if self.up_break and self.down_break and self.left_break and self.right_break then
      break
    end

    if not self.up_break then
      if self.center_line - count > self.topline then
        local line = self.center_line - count - 2
        self:one_key_set_extmark(line, self.cursor_virt_win_col - 1, count, {
          target_key = line + 1 .. "G",
        })
      else
        self.up_break = self.center_line - count
      end
    end

    if not self.down_break then
      if self.center_line + count < self.botline then
        local line = self.center_line + count
        self:one_key_set_extmark(line, self.cursor_virt_win_col - 1, count, {
          target_key = line + 1 .. "G",
        })
      else
        self.down_break = self.center_line + count
      end
    end

    if not self.left_break then
      if self.cursor_virt_win_col - count - 1 > 0 then
        local virt_win_col = self.cursor_virt_win_col - count - 2
        self:one_key_set_extmark(self.center_line - 1, virt_win_col, count, {
          target_key = virt_win_col + 1 .. "|",
        })
      else
        self.left_break = self.cursor_virt_win_col - count
      end
    end

    if not self.right_break then
      if self.cursor_virt_win_col + count < self.rightcol then
        local virt_win_col = self.cursor_virt_win_col + count
        self:one_key_set_extmark(self.center_line - 1, virt_win_col, count, {
          target_key = virt_win_col + 1 .. "|",
        })
      else
        self.right_break = self.cursor_virt_win_col + count
      end
    end
    count = count + 1
  end
end

function Key:two_key_up_down_set_extmark(i)
  local keymap, child_keymap = self:get_two_key_keymap(i)
  child_keymap.target_key = i .. "G"
  child_keymap.reset_mark = function()
    vim.api.nvim_buf_set_extmark(0, keymap.ns_id, i - 1, 0, {
      virt_text = { { child_keymap.key, "HopNextKey2" } },
      virt_text_win_col = self.cursor_virt_win_col - 1,
    })
  end
  vim.api.nvim_buf_set_extmark(0, keymap.ns_id, i - 1, 0, {
    virt_text = { { keymap.key, "HopNextKey1" }, { child_keymap.key, "HopNextKey2" } },
    virt_text_win_col = self.cursor_virt_win_col - 1,
  })
end

function Key:two_key_left_right_set_extmark(i)
  local keymap, child_keymap = self:get_two_key_keymap(i)
  child_keymap.target_key = i + self.leftcol .. "|"
  child_keymap.reset_mark = function()
    vim.api.nvim_buf_set_extmark(0, keymap.ns_id, self.center_line - 1, 0, {
      virt_text = { { child_keymap.key, "HopNextKey2" } },
      virt_text_win_col = i - 1,
    })
  end
  vim.api.nvim_buf_set_extmark(0, keymap.ns_id, self.center_line - 1, 0, {
    virt_text = { { keymap.key, "HopNextKey1" } },
    virt_text_win_col = i - 1,
  })
end

function Key:two_key()
  if self.up_break > 1 then
    for i = self.topline, self.up_break - 2 do
      self:two_key_up_down_set_extmark(i)
    end
  end

  if self.down_break <= self.botline then
    for i = self.down_break, self.botline do
      self:two_key_up_down_set_extmark(i)
    end
  end

  if self.left_break > 1 then
    for i = 1, self.left_break - 2 do
      self:two_key_left_right_set_extmark(i)
    end
  end
  if self.right_break <= self.rightcol then
    for i = self.right_break + 1, self.rightcol do
      self:two_key_left_right_set_extmark(i)
    end
  end
end

function Key:get_two_key_keymap(i)
  local parent = self.two_key_list[1]
  local keymap = get_keymap(parent)

  if parent.count == 26 then
    table.remove(self.two_key_list, 1)
  end

  return parent, keymap
end

function Key:on_key(keymap)
  vim.schedule(function()
    local char = vim.fn.nr2char(vim.fn.getchar())
    local child_keymap = keymap.child[char]
    if child_keymap then
      if child_keymap.target_key then
        vim.api.nvim_feedkeys(child_keymap.target_key, "nx", false)
      end
      if child_keymap.callback then
        child_keymap.callback()
      end
    end
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

function M.move_vertical_center()
  local virt_col = vim.fn.virtcol(".")
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local leftcol = wininfo.leftcol
  local topline = wininfo.topline
  local botline = wininfo.botline
  local rightcol = wininfo.width - wininfo.textoff
  local cursor_virt_win_col = virt_col - leftcol
  local line_count = botline - topline + 1
  local center_line = math.ceil(line_count / 2) + topline - 1
  vim.api.nvim_feedkeys("M", "nx", false)

  Line:init(topline, botline)
  Key:init({
    center_line = center_line,
    topline = topline,
    botline = botline,
    rightcol = rightcol,
    cursor_virt_win_col = cursor_virt_win_col,
    leftcol = leftcol,
  })
  Key:collect_two_keys()
  Key:one_key()
  Key:two_key()
  Key:on_key(Key.keymap)
end

return M
