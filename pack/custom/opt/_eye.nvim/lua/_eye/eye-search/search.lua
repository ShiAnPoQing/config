local M = {}

--- @class EyeSearch.Range
--- @field topline integer
--- @field botline integer
--- @field leftcol integer
--- @field rightcol integer
--- @field buf integer

--- @param pattern string
--- @param range  EyeSearch.Range
function M.search(pattern, range)
  local regex = vim.regex(pattern)
  local results = {}
  for i = range.topline, range.botline do
    local start_pos = 0

    while true do
      local start, end_ = regex:match_line(range.buf, i - 1, start_pos)

      if not start or not end_ or (start == 0 and end_ == 0) then
        break
      end

      local start_col = start + start_pos
      local end_col = end_ + start_pos

      if end_col > range.leftcol and start_col < range.rightcol then
        table.insert(results, {
          row = i,
          start_col = start_col,
          end_col = end_col,
        })
      end

      start_pos = start_pos + end_
    end
  end

  return results
end

return M
