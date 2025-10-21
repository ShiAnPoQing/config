local M = {}

function M.trigger()
  local line = vim.api.nvim_get_current_line()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local start_row = cursor[1] - 1
  local start_col = cursor[2]

  local line_left = line:sub(1, start_col)
  local line_right = line:sub(start_col + 1)

  local Reg = vim.regex("\\k*$")
  local s, e = Reg:match_str(line_left)

  if s and e then
    local keyword = line_left:sub(s, e)

    if keyword then
      vim.api.nvim_buf_set_text(0, start_row, start_col - #keyword, start_row, start_col, { "AAAA" })
    end
  end
end

return M
