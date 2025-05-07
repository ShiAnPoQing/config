local utils = require("utils.mark")
local M = {}

--- @alias Dir "left"|"right"

local function get_new_line(dir, line_to_start, line_to_end, text)
  local col_offset
  local new_line
  if dir == "right" then
    new_line = line_to_start .. line_to_end .. text
    col_offset = #line_to_end
  else
    new_line = text .. line_to_start .. line_to_end
    col_offset = - #line_to_start
  end

  return new_line, col_offset
end

local function line_split(line, col, text)
  local line_to_start = line:sub(1, col)
  local real_end_col = #line_to_start + vim.fn.strlen(text)
  local line_to_end = line:sub(real_end_col + 1)
  return line_to_start, line_to_end
end

--- @param dir Dir
--- @param text string
--- @param start_row integer
--- @param start_col integer
--- @param end_row integer
--- @param end_col integer
--- @param cursor_pos integer[]
local function select_one_line(dir, text, start_row, start_col, end_row, end_col, cursor_pos)
  local line = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)[1]
  local line_to_start, line_to_end = line_split(line, start_col, text)

  local new_line, col_offset = get_new_line(dir, line_to_start, line_to_end, text)

  vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, { new_line })
  utils.set_visual_mark(start_row, start_col + col_offset, end_row, end_col + col_offset)
  local exchange_cursor_key = cursor_pos[2] == start_col and "o" or ""
  vim.api.nvim_feedkeys("gv" .. exchange_cursor_key .. vim.api.nvim_replace_termcodes("<c-g>", true, true, true), "n",
    false)
end

--- @param dir Dir
--- @param text string
--- @param start_row integer
--- @param start_col integer
--- @param end_row integer
--- @param end_col integer
local function select_more_line(dir, text, start_row, start_col, end_row, end_col, cursor_pos)
  local texts = vim.split(text, "\n")
  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)

  local line_to_start = lines[1]:sub(1, start_col)
  local real_end_col = vim.fn.strlen(texts[#texts])
  local line_to_end = lines[#lines]:sub(real_end_col + 1)

  local new_line, col_offset = get_new_line(dir, line_to_start, line_to_end, text)

  vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, vim.split(new_line, "\n"))
  utils.set_visual_mark(start_row, start_col + col_offset, end_row, end_col)
  local exchange_cursor_key = cursor_pos[2] == start_col and "o" or ""
  vim.api.nvim_feedkeys("gv" .. exchange_cursor_key .. vim.api.nvim_replace_termcodes("<c-g>", true, true, true), "n",
    false)
end

--- @param dir Dir
local function select_mode_move(dir)
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_exec2([[execute "normal! \<C-G>y"]], {})
  local text = vim.fn.getreg('"')
  local start_row, start_col, end_row, end_col = utils.get_visual_mark(true)

  if end_row > start_row then
    select_more_line(dir, text, start_row, start_col, end_row, end_col, cursor_pos)
  else
    select_one_line(dir, text, start_row, start_col, end_row, end_col, cursor_pos)
  end
end

--- @param dir Dir
local function select_block_mode_move(dir)
  vim.api.nvim_exec2([[  execute "normal! \<C-g>y"  ]], {})
  local visual_texts = vim.split(vim.fn.getreg('"'), "\n")

  local start_row, start_col, end_row, end_col = utils.get_visual_mark(true)
  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)

  vim.api.nvim_win_set_cursor(0, { start_row, start_col })

  local new_lines = {}
  local first_col_offset
  local last_col_offset
  for i, line in ipairs(lines) do
    local _start_col;
    if i == 1 then
      _start_col = start_col
    else
      vim.api.nvim_feedkeys("j", "nx", false)
      _start_col = vim.api.nvim_win_get_cursor(0)[2]
    end

    local text = visual_texts[i]
    local line_to_start, line_to_end = line_split(line, _start_col, text)

    if dir == "right" then
      table.insert(new_lines, line_to_start .. line_to_end .. text)

      if i == 1 then
        first_col_offset = #line_to_end
      end

      if i == #lines then
        last_col_offset = #line_to_end
      end
    else
      table.insert(new_lines, text .. line_to_start .. line_to_end)

      if i == 1 then
        first_col_offset = - #line_to_start
      end
      if i == #lines then
        last_col_offset = - #line_to_start
      end
    end
  end

  vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, new_lines)
  utils.set_visual_mark(start_row, start_col + first_col_offset, end_row, end_col + last_col_offset)
  vim.api.nvim_feedkeys("gv" .. vim.api.nvim_replace_termcodes("<c-g>", true, true, true), "nx", false)
end

--- @param dir Dir
function M.select_start_end_move(dir)
  local mode = vim.api.nvim_get_mode().mode

  if mode == "s" then
    select_mode_move(dir)
  elseif mode == "" then
    select_block_mode_move(dir)
  end
end

return M
