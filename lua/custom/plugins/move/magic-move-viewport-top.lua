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

function Key:init(opt)
  self.keymap = {
    count = 0,
    child = {},
    ns_id = vim.api.nvim_create_namespace("test")
  }
  self.two_key_list = {}
  self.down_break = nil
  self.left_break = nil
  self.right_break = nil

  self.topline = opt.topline
  self.botline = opt.botline
  self.rightcol = opt.rightcol
  self.cursor_virt_win_col = opt.cursor_virt_win_col
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
      -- reset_keymap_mark(keymap)
      self:on_key(keymap)
    end
    table.insert(self.two_key_list, keymap)
  end
end

function Key:one_key()
  local count = 0

  while true do
    if self.down_break and self.left_break and self.right_break then
      break
    end

    if not self.down_break then
      if self.topline + count < self.botline then
        local line = self.topline + count
        local _keymap = get_keymap(self.keymap)
        _keymap.target_key = line + 1 .. "G"
        vim.api.nvim_buf_set_extmark(0, self.keymap.ns_id, line, 0, {
          virt_text = { { _keymap.key, "HopNextKey" } },
          virt_text_win_col = self.cursor_virt_win_col - 1
        })
      else
        self.down_break = self.topline + count
      end
    end

    if not self.left_break then
      if self.cursor_virt_win_col - count - 1 > 0 then

      else
        self.left_break = self.cursor_virt_win_col - count
      end
    end

    if not self.right_break then
      if self.cursor_virt_win_col + count < self.rightcol then
      else
        self.right_break = self.cursor_virt_win_col + count
      end
    end

    count = count + 1
  end
end

function Key:two_key()

end

function Key:clean_mark()
  vim.api.nvim_buf_clear_namespace(0, self.keymap.ns_id, 0, -1)
  for k, value in pairs(self.keymap.child) do
    if value.ns_id then
      vim.api.nvim_buf_clear_namespace(0, value.ns_id, 0, -1)
    end
  end
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
  end)
end

function M.move_viewport_top()
  local virt_col = vim.fn.virtcol(".")
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local leftcol = wininfo.leftcol
  local topline = wininfo.topline
  local botline = wininfo.botline
  local rightcol = wininfo.width - wininfo.textoff
  local cursor_virt_win_col = virt_col - leftcol
  vim.api.nvim_feedkeys("H", "nx", false)

  Line:init(topline, botline)
  Key:init({
    topline = topline,
    botline = botline,
    rightcol = rightcol,
    cursor_virt_win_col = cursor_virt_win_col
  })
  Key:collect_two_keys()
  Key:one_key()
  Key:two_key()
  Key:on_key(Key.keymap)
end

return M
