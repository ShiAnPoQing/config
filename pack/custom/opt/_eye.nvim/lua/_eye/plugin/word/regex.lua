--- @class _Eye.Regex
--- @field regex vim.regex
--- @field config Eye.Regex.Config
--- @field matches Eye.Regex.Match[][]
local M = {}
M.__index = M

--- @class _Eye.Regex.Config
--- @field should_capture? boolean

--- @class _Eye.Regex.Spec
--- @field buf integer
--- @field topline integer
--- @field botline integer
--- @field leftcol integer
--- @field rightcol integer
--- @field should_capture? boolean

--- @class _Eye.Regex.Match
--- @field row integer
--- @field start_col integer
--- @field end_col integer
--- @field start_virt_col integer
--- @field end_virt_col integer
--- @field start_virt_win_col integer
--- @field end_virt_win_col integer
--- @field capture? string

--- @class _Eye.Regex.BuiltinRegex
--- @field word.inner string
--- @field word.outer string
--- @field WORD.inner string
--- @field WORD.outer string

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

function M:__collect(spec, row, start_col, end_col, current_line)
  local start_virt_col = get_display_width(spec.buf, row - 1, 0, row - 1, start_col)
  local end_virt_col = get_display_width(spec.buf, row - 1, 0, row - 1, end_col) - 1
  --- @type Eye.Regex.Match
  local match = {
    row = row,
    start_col = start_col,
    end_col = end_col,
    start_virt_col = start_virt_col,
    end_virt_col = end_virt_col,
    start_virt_win_col = start_virt_col - spec.leftcol,
    end_virt_win_col = end_virt_col - spec.leftcol,
  }
  if spec.should_capture then
    match.capture = current_line:sub(start_col + 1, end_col)
  end
  table.insert(self.matches[#self.matches], match)
end

--- @param spec Eye.Regex.Spec
function M:match_spec(spec)
  for i = spec.topline, spec.botline do
    table.insert(self.matches, {})
    local start_pos = 0

    while true do
      local start, end_ = self.regex:match_line(spec.buf, i - 1, start_pos)
      local current_line = spec.should_capture and vim.api.nvim_buf_get_lines(spec.buf, i - 1, i, false)[1]

      if not start or not end_ or (start == 0 and end_ == 0) then
        break
      end

      local start_col = start + start_pos
      local end_col = end_ + start_pos

      if end_col > spec.leftcol and start_col < spec.rightcol then
        self:__collect(spec, i, start_col, end_col, current_line)
      end

      start_pos = start_pos + end_
    end
  end
end

--- @param specs Eye.Regex.Spec[]
function M:match(specs)
  specs = vim.tbl_deep_extend("force", {}, specs or {})
  for _, spec in ipairs(specs) do
    self:match_spec(spec)
  end
end

--- @param regex string | fun(builtin: Eye.Regex.BuiltinRegex): string
--- @param config? Eye.Regex.Config
function M:new(regex, config)
  local o = setmetatable({}, self)
  o.regex = vim.regex(get_pattern(regex))
  o.config = vim.tbl_deep_extend("force", {}, config or {})
  o.matches = {}
  return o
end

return M
