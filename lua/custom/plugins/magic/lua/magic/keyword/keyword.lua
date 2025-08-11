local M = {}

local BuiltinKeyword = {
  ["word_inner"] = "\\k\\+",
  ["word_outer"] = "\\k\\+\\s*",
  ["WORD_inner"] = "\\S\\+",
  ["WORD_outer"] = "\\S\\+\\s*",
}

--- @class KeywordOpts
--- @field keyword string | fun(BuiltinKeyword: table): string
--- @field topline number
--- @field botline number
--- @field leftcol number
--- @field rightcol number
--- @field match_callback fun(count: number)

local function get_display_width(start_row, start_col, end_row, end_col)
  local text = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})[1]
  local display_width = vim.fn.strdisplaywidth(text)
  return display_width
end

function M:collect_keyword(i, keyword_start, keyword_end)
  local virt_start_col = get_display_width(i - 1, 0, i - 1, keyword_start)
  local virt_end_col = get_display_width(i - 1, 0, i - 1, keyword_end) - 1

  self.keyword_count = self.keyword_count + 1
  table.insert(self.matches[#self.matches], {
    start_col = keyword_start,
    end_col = keyword_end,
    virt_start_col = virt_start_col,
    virt_end_col = virt_end_col,
    virt_win_start_col = virt_start_col - self.leftcol,
    virt_win_end_col = virt_end_col - self.leftcol,
  })
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
    local start_dislay_width = get_display_width(i - 1, 0, i - 1, keyword_start)
    local end_dislay_width = get_display_width(i - 1, 0, i - 1, keyword_end)

    if not (start_dislay_width < leftcol or end_dislay_width > rightcol) then
      self:collect_keyword(i, keyword_start, keyword_end)
    end

    start_pos = start_pos + end_
  end
end

function M:match()
  for i = self.topline, self.botline do
    self:get_keyword(i, self.leftcol, self.rightcol)
  end
  if type(self.match_callback) == "function" then
    self.match_callback(self.keyword_count)
  end
end

function M:clean()
  for key, value in pairs(self) do
    if type(value) ~= "function" then
      self[key] = nil
    end
  end
end

function M:match_foreach(callback)
  local count = 0
  while true do
    if count > 1000 then
      break
    end

    if self.up_break and self.down_break then
      break
    end

    if self.cursor_row - count >= self.topline then
      local match = self.matches[self.cursor_row - count - self.topline + 1]
      for _, value in ipairs(match) do
        local param = vim.tbl_extend("force", {
          line = self.cursor_row - count - 1,
        }, value)
        callback(param)
      end
    else
      self.up_break = true
    end

    if self.cursor_row + count < self.botline then
      local match = self.matches[self.cursor_row + count - self.topline + 2]
      for _, value in ipairs(match) do
        local param = vim.tbl_extend("force", {
          line = self.cursor_row + count,
        }, value)
        callback(param)
      end
    else
      self.down_break = true
    end

    count = count + 1
  end
end

--- @param opts KeywordOpts
function M:init(opts)
  self.topline = opts.topline
  self.botline = opts.botline
  self.leftcol = opts.leftcol
  self.rightcol = opts.rightcol
  self.cursor_row = vim.api.nvim_win_get_cursor(0)[1]

  self.keyword_count = 0
  self.matches = {}
  local keyword = opts.keyword
  if type(keyword) == "function" then
    local k = keyword(BuiltinKeyword)
    if type(k) == "string" then
      self.regex = vim.regex(k or "")
    end
  elseif type(keyword) == "string" then
    self.regex = vim.regex(keyword or "")
  end
  self.match_callback = opts.match_callback
  self.up_break = nil
  self.down_break = nil
end

return M
