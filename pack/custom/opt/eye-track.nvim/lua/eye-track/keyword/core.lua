local M = {}

--- @class EyeTrack.Keyword.Options
--- @field keyword string | fun(BuiltinKeyword: table): string
--- @field topline number
--- @field botline number
--- @field leftcol number
--- @field rightcol number

local BUILTINKEYWORDMAP = {
  ["word_inner"] = "\\k\\+",
  ["word_outer"] = "\\k\\+\\s*",
  ["WORD_inner"] = "\\S\\+",
  ["WORD_outer"] = "\\S\\+\\s*",
}

local function get_pattern(pattern)
  if type(pattern) == "function" then
    pattern = pattern(BUILTINKEYWORDMAP)
    if type(pattern) ~= "string" then
      pattern = ""
    end
  else
    if type(pattern) ~= "string" then
      pattern = ""
    end
  end

  return pattern or ""
end

function M:match()
  for i = self.topline, self.botline do
    self:get_keyword(i, self.leftcol, self.rightcol)
  end
end

local function get_display_width(start_row, start_col, end_row, end_col)
  local text = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})[1]
  local display_width = vim.fn.strdisplaywidth(text)
  return display_width
end

function M:collect_keyword(i, start_col, end_col, current_line)
  local virt_start_col = get_display_width(i - 1, 0, i - 1, start_col)
  local virt_end_col = get_display_width(i - 1, 0, i - 1, end_col) - 1

  local data = {
    start_col = start_col,
    end_col = end_col,
    virt_start_col = virt_start_col,
    virt_end_col = virt_end_col,
    virt_win_start_col = virt_start_col - self.leftcol,
    virt_win_end_col = virt_end_col - self.leftcol,
  }
  if self.should_capture then
    data.capture = current_line:sub(start_col + 1, end_col)
  end
  table.insert(self.matches[#self.matches], data)
end

function M:get_keyword(i, leftcol, rightcol)
  table.insert(self.matches, {})
  local start_pos = 0

  while true do
    local start, end_ = self.regex:match_line(0, i - 1, start_pos)
    local current_line = self.should_capture and vim.api.nvim_buf_get_lines(0, i - 1, i, false)[1]

    if not start or not end_ or (start == 0 and end_ == 0) then
      break
    end

    local start_col = start + start_pos
    local end_col = end_ + start_pos

    if end_col > leftcol then
      self:collect_keyword(i, start_col, end_col, current_line)
    end

    start_pos = start_pos + end_
  end
end

--- @param opts EyeTrack.Keyword.Options
function M:init(opts)
  self.topline = opts.topline
  self.botline = opts.botline
  self.leftcol = opts.leftcol
  self.rightcol = opts.rightcol
  self.cursor_row = vim.api.nvim_win_get_cursor(0)[1]

  self.matches = {}
  self.regex = vim.regex(get_pattern(opts.keyword))
  self.up_break = nil
  self.down_break = nil
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

--- @param opts EyeTrack.Keyword.Options
--- @return table<EyeTrack.Key.RegisterOptions>
function M:main(opts)
  --- @type table<EyeTrack.Key.RegisterOptions>
  local matchs = {}
  self:init(opts)
  self:match()
  self:match_foreach(function(p)
    table.insert(matchs, {
      line = p.line,
      virt_col = p.virt_win_start_col,
      callback = function() end,
    })
  end)
  return matchs
end

return M
