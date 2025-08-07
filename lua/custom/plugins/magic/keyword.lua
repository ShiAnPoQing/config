local M = {}
function M:init(opt)
  self.keyword_count = 0
  self.matches = {}
  self.keyword_ns_id = vim.api.nvim_create_namespace("custom-keyword-highlight")
  self.regex = vim.regex(opt.keyword or "")
  self.cursor_row = opt.cursor[1]
  self.topline = opt.topline
  self.botline = opt.botline
  self.leftcol = opt.leftcol
  self.rightcol = opt.rightcol
  self.up_break = nil
  self.down_break = nil
end

function M:collect_keyword(i, keyword_start, keyword_end, byte_start, byte_end)
  self.keyword_count = self.keyword_count + 1
  table.insert(self.matches[#self.matches], {
    keyword_end = keyword_end,
    keyword_start = keyword_start,
    byte_start = byte_start,
    byte_end = byte_end,
  })
end

function M:set_keyword_callback(callback)
  local count = 0
  while true do
    if self.up_break and self.down_break then
      break
    end

    if self.cursor_row - count >= self.topline then
      local match = self.matches[self.cursor_row - count - self.topline + 1]
      for _, value in ipairs(match) do
        callback(self.cursor_row - count - 1, value.keyword_start, value.keyword_end, value.byte_start, value.byte_end)
      end
    else
      self.up_break = true
    end

    if self.cursor_row + count < self.botline then
      local match = self.matches[self.cursor_row + count - self.topline + 2]
      for _, value in ipairs(match) do
        callback(self.cursor_row + count, value.keyword_start, value.keyword_end, value.byte_start, value.byte_end)
      end
    else
      self.down_break = true
    end

    count = count + 1
  end
end

function M:get_keyword(i, leftcol, rightcol)
  table.insert(self.matches, {})
  local start_pos = 0

  while true do
    local start, end_ = self.regex:match_line(0, i - 1, start_pos)

    if not start or not end_ or (start == 0 and end_ == 0) then
      break
    end

    local keyword_start = start + start_pos
    local keyword_end = end_ + start_pos
    if keyword_start < leftcol or keyword_end > rightcol then
      return
    end
    local before_text = vim.api.nvim_buf_get_text(0, i - 1, 0, i - 1, keyword_start, {})[1]
    local text = vim.api.nvim_buf_get_text(0, i - 1, 0, i - 1, keyword_end, {})[1]
    local display_start = vim.fn.strdisplaywidth(before_text)
    local display_end = vim.fn.strdisplaywidth(text) - 1
    self:collect_keyword(i, display_start, display_end, keyword_start, keyword_end)
    -- self:collect_keyword(i, keyword_start, keyword_end)
    start_pos = start_pos + end_
  end
end

function M:match_keyword()
  for i = self.topline, self.botline do
    M:get_keyword(i, self.leftcol, self.rightcol)
  end
end

function M:clean()
  for key, value in pairs(self) do
    if type(value) ~= "function" then
      self[key] = nil
    end
  end
end
return M
