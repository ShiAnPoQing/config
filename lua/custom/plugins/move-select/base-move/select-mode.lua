local utils = require("utils.mark")

local M = {}

local function get_new_line(dir, line_to_start, line_to_end, text)
  local col_offset;
  local new_line;

  if dir == "right" then
    local line_to_end_part1 = vim.fn.strcharpart(line_to_end, 0, 1)
    local line_to_end_part2 = vim.fn.strcharpart(line_to_end, 1)
    new_line = line_to_start .. line_to_end_part1 .. text .. line_to_end_part2
    col_offset = #line_to_end_part1
  else
    local line_to_start_reverse = vim.fn.reverse(line_to_start)
    local line_to_start_part2 = vim.fn.strcharpart(line_to_start_reverse, 0, 1)
    local line_to_start_part1 = vim.fn.reverse(vim.fn.strcharpart(line_to_start_reverse, 1))
    new_line = line_to_start_part1 .. text .. line_to_start_part2 .. line_to_end
    col_offset = - #line_to_start_part2
  end

  return new_line, col_offset
end

local function reverse_cursor(cursor_pos, start_col)
  local exchange_cursor_key = cursor_pos[2] == start_col and "o" or ""
  vim.api.nvim_feedkeys("gv" .. exchange_cursor_key .. vim.api.nvim_replace_termcodes("<c-g>", true, true, true), "n",
    false)
end

local function select_one_line(dir, text, start_row, start_col, end_row, end_col, cursor_pos)
  local line = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)[1]

  local line_to_start = line:sub(1, start_col)
  local line_to_end = line:sub(#line_to_start + vim.fn.strlen(text) + 1)

  local new_line, col_offset = get_new_line(dir, line_to_start, line_to_end, text)

  vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, { new_line })
  utils.set_visual_mark(start_row, start_col + col_offset, end_row, end_col + col_offset)
  reverse_cursor(cursor_pos, start_col)
end

local function select_more_line(dir, text, start_row, start_col, end_row, end_col, cursor_pos)
  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
  local texts = vim.fn.split(text, "\n")
  local last_text = texts[#texts]

  local line_to_start = lines[1]:sub(1, start_col)
  local line_to_end = lines[#lines]:sub(vim.fn.strlen(last_text) + 1)

  local new_line, col_offset = get_new_line(dir, line_to_start, line_to_end, text)

  vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, vim.fn.split(new_line, "\n"))
  utils.set_visual_mark(start_row, start_col + col_offset, end_row, end_col)
  reverse_cursor(cursor_pos, start_col)
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
