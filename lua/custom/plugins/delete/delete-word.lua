local M = {}

local Key = {}
local Keyword = {}
local KEYS = "abcdefghijklmnopqrstuvwxyz"

local function get_random_key(keyinfo)
  if keyinfo.count == 26 then
    return nil
  end

  local random = math.random(26)
  local key = KEYS:sub(random, random)

  if keyinfo.map[key] == nil then
    keyinfo.map[key] = {
      key = key
    }
    keyinfo.count = keyinfo.count + 1
    return keyinfo.map[key]
  else
    return get_random_key(keyinfo)
  end
end

function Keyword:init(opt)
  self.matches = {}
  self.keyword_ns_id = vim.api.nvim_create_namespace("custom-keyword-highlight")
  self.regex = vim.regex("\\k\\+")
  self.cursor_row = opt.cursor[1]
  self.topline = opt.topline
  self.botline = opt.botline
  self.up_break = nil
  self.down_break = nil
end

function Keyword:set_keyword_hl(row, start_col, end_col)
  vim.api.nvim_buf_set_extmark(0, self.keyword_ns_id, row, start_col, {
    end_row = row,
    end_col = end_col,
    hl_group = "Search"
  })
end

function Keyword:_set_keyword_hl(row, start_col, end_col)
  vim.api.nvim_buf_set_extmark(0, self.keyword_ns_id, row, start_col, {
    virt_text_pos = "inline",
    virt_text = { { "?", "CurSearch" } }
  })
end

function Keyword:del_keyword_hl()
  vim.api.nvim_buf_clear_namespace(0, self.keyword_ns_id, 0, -1)
end

function Keyword:collect_keyword(i, keyword_start, keyword_end)
  table.insert(self.matches[#self.matches], {
    keyword_end = keyword_end,
    keyword_start = keyword_start,
  })
end

function Keyword:set_keyword_target()
  local count = 0
  while true do
    if self.up_break and self.down_break then
      break
    end

    if self.cursor_row - count > self.topline then
      local match = self.matches[self.cursor_row - count - self.topline]
      for index, value in ipairs(match) do
        Key:get(self.cursor_row - count - 2, value.keyword_start, value.keyword_end)
      end
    else
      self.up_break = true
    end

    if self.cursor_row + count <= self.botline then
      local match = self.matches[self.cursor_row + count - self.topline + 1]
      for index, value in ipairs(match) do
        self:_set_keyword_hl(self.cursor_row + count - 1, value.keyword_start, value.keyword_end)
      end
    else
      self.down_break = true
    end

    count = count + 1
  end
end

function Key:init()
  self.keyinfo = {
    map = {},
    count = 0,
    ns_id = vim.api.nvim_create_namespace("test")
  }
  self.current_keyinfo = self.keyinfo
end

function Key:get(line, start_col, end_col)
  local keyinfo = get_random_key(self.current_keyinfo)
  if keyinfo then
    vim.api.nvim_buf_set_extmark(0, vim.api.nvim_create_namespace("tes"), line, start_col, {
      virt_text_pos = "inline",
      virt_text = { { keyinfo.key, "HopNextKey1" } }
    })
  end
end

local function iter_viewport_lines(topline, botline, callback)
  for i = topline, botline do
    callback(i)
  end
end

function Keyword:match_keyword(i, leftcol, rightcol)
  table.insert(self.matches, {})
  local start_pos = 0
  while true do
    local start, end_ = self.regex:match_line(0, i - 1, start_pos)
    if not start then
      break
    end

    local keyword_start = start + start_pos
    local keyword_end = end_ + start_pos
    if keyword_start < leftcol or keyword_end > rightcol then
      return
    end
    self:collect_keyword(i, keyword_start, keyword_end)
    self:set_keyword_hl(i - 1, keyword_start, keyword_end)
    start_pos = start_pos + end_
  end
end

function M.magic_delete_word()
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local topline = wininfo.topline
  local botline = wininfo.botline
  local leftcol = wininfo.leftcol
  local rightcol = leftcol + wininfo.width - wininfo.textoff
  local cursor = vim.api.nvim_win_get_cursor(0)

  Keyword:init({
    cursor = cursor,
    topline = topline,
    botline = botline,
  })
  Key:init()

  iter_viewport_lines(topline, botline, function(i)
    Keyword:match_keyword(i, leftcol, rightcol)
  end)

  Keyword:set_keyword_target()
end

return M
