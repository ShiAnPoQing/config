local utils = require("utils.mark")
local M = {}
local Select = {}
local Line = {}

local function select(cursor_pos, start_col)
  local ctrl_v = vim.api.nvim_replace_termcodes("<C-v>", true, true, true)
  local ctrl_g = vim.api.nvim_replace_termcodes("<C-g>", true, true, true)
  local key = cursor_pos[2] == start_col and "o" or ""
  vim.api.nvim_feedkeys("gv" .. ctrl_v .. key .. ctrl_g, "nx", false)
end

function Line:init(start_row, end_row)
  self.lines = vim.api.nvim_buf_get_lines(0, start_row, end_row, false)
  self.new_lines = {}
  self.line_parts = {}
  self.revise_char_count = 0
  self.char_display_width = 0
end

function Line:set_line_left_part(i, col)
  local select_text_left_line = self.lines[i]:sub(1, col)

  table.insert(self.line_parts, {
    select_text_left_line = select_text_left_line
  })
end

function Line:set_line_right_part(i, select_text)
  local line = self.lines[i]
  local line_part = self.line_parts[i]
  line_part.select_text = select_text
  line_part.select_text_right_line = line:sub(#line_part.select_text_left_line + vim.fn.strlen(select_text) + 1)
end

function Line:merger_lines()
  self:revise_chars()
  self:line_concat()
end

function Line:revise_chars()
  self.revise_char_count = 0

  for _, part in ipairs(self.line_parts) do
    self:revise_char(1, part)
  end

  if self.revise_char_count < #self.line_parts then
    self:revise_chars()
  end
end

function Line:revise_char(col, line_part)

end

function Line:line_concat()
  for _, part in ipairs(self.line_parts) do

  end
end

function Select:init()
  self.texts = vim.split(vim.fn.getreg('"'), "\n")
  self.text_display_width = nil
  self.balance = true
end

function Select:revise_select_start_char(i)
  local text = self.texts[i]
  local real_first_char = vim.fn.getreg('"')
  self.texts[i] = real_first_char .. vim.fn.strcharpart(text, 1)
end

function Select:revise_select_end_char(i)
  local text = self.texts[i]
  local real_end_char = vim.fn.getreg('"')
  local select_text = vim.fn.strcharpart(text, 0, vim.fn.strcharlen(text) - 1) .. real_end_char
  self.texts[i] = select_text
  self:check_balance(select_text)
end

function Select:check_balance(select_text)
  if self.text_display_width ~= nil then
    if self.text_display_width ~= vim.fn.strdisplaywidth(select_text) then
      self.balance = false
    end
  else
    self.text_display_width = vim.fn.strdisplaywidth(select_text)
  end
end

local function move_to_select_text_start_col(callback, start_row, start_col, line_count)
  vim.api.nvim_win_set_cursor(0, { start_row, start_col })
  vim.api.nvim_feedkeys("k", "nx", false)
  for i = 1, line_count do
    vim.api.nvim_feedkeys("jvy", "nx", false)
    callback(i, vim.api.nvim_win_get_cursor(0)[2])
  end
end

local function move_to_select_text_end_col(callback, end_row, end_col, line_count)
  vim.api.nvim_win_set_cursor(0, { end_row, end_col })
  vim.api.nvim_feedkeys("j", "nx", false)
  local end_poss = {}
  for i = 1, line_count do
    vim.api.nvim_feedkeys("k", "nx", false)
    table.insert(end_poss, 1, vim.api.nvim_win_get_cursor(0))
  end

  for i = 1, line_count do
    vim.api.nvim_win_set_cursor(0, end_poss[i])
    vim.api.nvim_feedkeys("vy", "nx", false)
    callback(i)
  end
end

--- @param dir "left"|"right"
function M.select_block_mode_move(dir)
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_exec2([[execute "normal! \<C-g>y"]], {})
  local start_row, start_col, end_row, end_col = utils.get_visual_mark(true)

  Select:init()
  Line:init(start_row - 1, end_row)

  move_to_select_text_start_col(function(i, col)
    Select:revise_select_start_char(i)
    Line:set_line_left_part(i, col)
  end, start_row, start_col, end_row - start_row + 1)

  move_to_select_text_end_col(function(i)
    Select:revise_select_end_char(i)
    Line:set_line_right_part(i, Select.texts[i])
  end, end_row, end_col, end_row - start_row + 1)

  if Select.balance == false then
    utils.set_visual_mark(start_row, start_col, end_row, end_col)
    select(cursor_pos, start_col)
    return
  end
  print(vim.inspect(Select.texts))

  Line:merger_lines()
end

return M
