local utils = require("utils.mark")
local M = {}

local function select(cursor_pos, start_col)
  local ctrl_g = vim.api.nvim_replace_termcodes("<C-g>", true, true, true)
  local key = cursor_pos[2] == start_col and "o" or ""
  vim.api.nvim_feedkeys("gv" .. key .. ctrl_g, "nx", false)
end

local function get_new_line(dir, line_to_start, line_to_end, text)
  local col_offset
  local new_line
  if dir == "right" then
    new_line = line_to_start .. line_to_end .. text
    col_offset = #line_to_end
  else
    new_line = text .. line_to_start .. line_to_end
    col_offset = -#line_to_start
  end

  return new_line, col_offset
end

local function select_one_line(dir, text, start_row, start_col, end_row, end_col, cursor_pos)
  local line = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)[1]
  local line_to_start = line:sub(1, start_col)
  local line_to_end = vim.fn.strcharpart(line, vim.fn.strcharlen(line_to_start .. text))
  local new_line, col_offset = get_new_line(dir, line_to_start, line_to_end, text)
  vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, { new_line })
  utils.set_visual_mark(start_row, start_col + col_offset, end_row, end_col + col_offset)
  select(cursor_pos, start_col)
end

local function select_more_line(dir, text, start_row, start_col, end_row, end_col, cursor_pos)
  local texts = vim.split(text, "\n")
  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
  local line_to_start = lines[1]:sub(1, start_col)
  local line_to_end = lines[#lines]:sub(vim.fn.strlen(texts[#texts]) + 1)
  local new_line, col_offset = get_new_line(dir, line_to_start, line_to_end, text)
  vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, vim.split(new_line, "\n"))
  utils.set_visual_mark(start_row, start_col + col_offset, end_row, end_col)
  select(cursor_pos, start_col)
end

--- @param dir "left"|"right"
function M.select_mode_move(dir)
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_exec2([[execute "normal! \<C-g>y"]], {})
  local text = vim.fn.getreg('"')
  local start_row, start_col, end_row, end_col = utils.get_visual_mark(true)

  if end_row > start_row then
    select_more_line(dir, text, start_row, start_col, end_row, end_col, cursor_pos)
  else
    select_one_line(dir, text, start_row, start_col, end_row, end_col, cursor_pos)
  end
end

return M
