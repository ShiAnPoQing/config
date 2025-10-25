local M = {}

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

function M:match() end

function M:init(opts)
  self.topline = opts.topline
  self.botline = opts.botline
  self.leftcol = opts.leftcol
  self.rightcol = opts.rightcol
  self.cursor_row = vim.api.nvim_win_get_cursor(0)[1]

  self.keyword_count = 0
  self.matches = {}
  self.regex = vim.regex(get_pattern(opts.keyword))
  self.should_capture = opts.should_capture
  self.match_callback = opts.match_callback
  self.up_break = nil
  self.down_break = nil
end

return M
