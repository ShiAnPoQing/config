local utils = require("utils.mark")
local Select = require("custom.plugins.move-select.utils.select-block-mode")

local M = {}

local Line = {}

local left = setmetatable({}, { __index = Line })
local right = setmetatable({}, { __index = Line })

local function select(cursor_pos, start_col)
  local ctrl_v = vim.api.nvim_replace_termcodes("<C-v>", true, true, true)
  local ctrl_g = vim.api.nvim_replace_termcodes("<C-g>", true, true, true)
  local key = cursor_pos[2] == start_col and "o" or ""
  vim.api.nvim_feedkeys("gv" .. ctrl_v .. key .. ctrl_g, "nx", false)
end

function left:get_char(part, col)
  local source = part.select_text_left_line
  return vim.fn.strcharpart(source, vim.fn.strcharlen(source) - col)
end

function right:get_char(part, col)
  local source = part.select_text_right_line
  local char = vim.fn.strcharpart(source, 0, col)

  local char_len = vim.fn.strcharlen(char)
  if char_len < col and self.revise_char_count ~= #self.line_parts then
    char = char .. string.rep(" ", col - char_len)
  end
  return char
end

function left:get_new_line(part)
  local select_text_left_line_char_len = vim.fn.strcharlen(part.select_text_left_line)
  local char_len = vim.fn.strcharlen(part.char)
  return vim.fn.strcharpart(part.select_text_left_line, 0, select_text_left_line_char_len - char_len) ..
      part.select_text .. part.char .. part.select_text_right_line
end

function right:get_new_line(part)
  return part.select_text_left_line ..
      part.char .. part.select_text .. vim.fn.strcharpart(part.select_text_right_line, vim.fn.strcharlen(part.char))
end

function left:get_mark_offset()
  return - #self.line_parts[1].char, - #self.line_parts[#self.line_parts].char
end

function right:get_mark_offset()
  return #self.line_parts[1].char, #self.line_parts[#self.line_parts].char
end

function Line:init(dir, start_row, end_row)
  self.lines = vim.api.nvim_buf_get_lines(0, start_row, end_row, false)
  self.line_parts = {}
  self.new_lines = {}
  self.char_display_width = 0
  self.revise_char_count = 0
  self.stop = nil
  if dir == "right" then
    self.Action = right
  else
    self.Action = left
  end
end

function Line:set_line_left_part(i, col)
  local select_text_left_line = self.lines[i]:sub(1, col)

  table.insert(self.line_parts, {
    select_text_left_line = select_text_left_line,
  })
end

function Line:set_line_right_part(i, select_text)
  local line = self.lines[i]
  local line_part = self.line_parts[i]

  line_part.select_text = select_text
  line_part.select_text_right_line = line:sub(#line_part.select_text_left_line + vim.fn.strlen(select_text) + 1)
end

function Line:revise_chars()
  if self.stop == true then return end

  self.revise_char_count = 0
  for _, part in ipairs(self.line_parts) do
    if self.stop == true then break end
    self:revise_char(1, part)
  end

  if self.revise_char_count < #self.line_parts then
    self:revise_chars()
  end
end

function Line:revise_char(col, line_part)
  local char = self.Action:get_char(line_part, col)

  local char_display_width = vim.fn.strdisplaywidth(char)
  if char_display_width > self.char_display_width then
    self.char_display_width = char_display_width
    line_part.char = char
  elseif char_display_width == self.char_display_width then
    line_part.char = char
    self.revise_char_count = self.revise_char_count + 1
  elseif char_display_width < self.char_display_width then
    self:revise_char(col + 1, line_part)
  end
end

function Line:line_concat()
  if self.stop == true then return end

  for _, part in ipairs(self.line_parts) do
    table.insert(self.new_lines, Line.Action:get_new_line(part))
  end
end

function Line:merger_lines()
  self:revise_chars()
  self:line_concat()
end

function Line:set_lines(start_row, start_col, end_row, end_col, cursor_pos)
  if self.stop == true then
    utils.set_visual_mark(start_row, start_col, end_row, end_col)
    select(cursor_pos, start_col)
    return
  end

  vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, self.new_lines)

  local start_col_offset, end_col_offset = self.Action:get_mark_offset()
  utils.set_visual_mark(start_row, start_col + start_col_offset, end_row,
    end_col + end_col_offset)
  select(cursor_pos, start_col)
end

--- @param dir "left"|"right"
function M.select_block_mode_move(dir)
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_exec2([[execute "normal! \<C-g>y"]], {})
  local start_row, start_col, end_row, end_col = utils.get_visual_mark(true)

  Select:init()
  Line:init(dir, start_row - 1, end_row)

  Select:select_text_iter(function(i, col)
    Select:revise_select_start_char(i)
    Line:set_line_left_part(i, col)
  end, function(i)
    Select:revise_select_end_char(i)
    Line:set_line_right_part(i, Select.texts[i])
  end, start_row, start_col, end_row, end_col)

  if Select.balance == false then
    utils.set_visual_mark(start_row, start_col, end_row, end_col)
    select(cursor_pos, start_col)
    return
  end

  Line:merger_lines()
  Line:set_lines(start_row, start_col, end_row, end_col, cursor_pos)
end

return M
