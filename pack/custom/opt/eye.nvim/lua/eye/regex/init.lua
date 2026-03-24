--- @class Eye.Regex
--- @field topline integer
--- @field botline integer
--- @field leftcol integer
--- @field rightcol integer
--- @field matches Eye.Regex.Match[][]
local M = {}
M.__index = M

--- @class Eye.Regex.Config
--- @field regex string | fun(builtin: table): string
--- @field topline integer
--- @field botline integer
--- @field leftcol integer
--- @field rightcol integer
--- @field should_capture? boolean
--- @field buf integer

--- @class Eye.Regex.Match
--- @field row integer
--- @field start_col integer
--- @field end_col integer
--- @field start_virt_col integer
--- @field end_virt_col integer
--- @field start_virt_win_col integer
--- @field end_virt_win_col integer
--- @field capture? string

local BUILTIN_REGEX_MAP = {
  ["word.inner"] = "\\k\\+",
  ["word.outer"] = "\\k\\+\\s*",
  ["WORD.inner"] = "\\S\\+",
  ["WORD.outer"] = "\\S\\+\\s*",
}

local function get_pattern(pattern)
  if type(pattern) == "function" then
    pattern = pattern(BUILTIN_REGEX_MAP)
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

local function get_display_width(buf, start_row, start_col, end_row, end_col)
  local text = vim.api.nvim_buf_get_text(buf, start_row, start_col, end_row, end_col, {})[1]
  local display_width = vim.fn.strdisplaywidth(text)
  return display_width
end

local function collect(self, row, start_col, end_col, current_line)
  local start_virt_col = get_display_width(self.buf, row - 1, 0, row - 1, start_col)
  local end_virt_col = get_display_width(self.buf, row - 1, 0, row - 1, end_col) - 1

  --- @type Eye.Regex.Match
  local match = {
    row = row,
    start_col = start_col,
    end_col = end_col,
    start_virt_col = start_virt_col,
    end_virt_col = end_virt_col,
    start_virt_win_col = start_virt_col - self.leftcol,
    end_virt_win_col = end_virt_col - self.leftcol,
  }
  if self.should_capture then
    match.capture = current_line:sub(start_col + 1, end_col)
  end
  table.insert(self.matches[#self.matches], match)
end

local function match(self, i, leftcol, rightcol)
  table.insert(self.matches, {})
  local start_pos = 0

  while true do
    local start, end_ = self.regex:match_line(self.buf, i - 1, start_pos)
    local current_line = self.should_capture and vim.api.nvim_buf_get_lines(self.buf, i - 1, i, false)[1]

    if not start or not end_ or (start == 0 and end_ == 0) then
      break
    end

    local start_col = start + start_pos
    local end_col = end_ + start_pos

    if end_col > leftcol and start_col < rightcol then
      collect(self, i, start_col, end_col, current_line)
    end

    start_pos = start_pos + end_
  end
end

function M:_match()
  for i = self.topline, self.botline do
    match(self, i, self.leftcol, self.rightcol)
  end
end

--- @param config Eye.Regex.Config
function M:new(config)
  local o = setmetatable({}, self)
  o.buf = config.buf
  o.topline = config.topline
  o.botline = config.botline
  o.leftcol = config.leftcol
  o.rightcol = config.rightcol
  o.matches = {}
  o.regex = vim.regex(get_pattern(config.regex))
  o:_match()
  return o
end

return M
