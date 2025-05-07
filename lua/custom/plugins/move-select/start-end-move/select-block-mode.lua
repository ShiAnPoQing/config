local M = {}

local utils = require("utils.mark")
local Select = require("custom.plugins.move-select.utils.select-block-mode")

local Line = {}

local left = setmetatable({}, { __index = Line })
local right = setmetatable({}, { __index = Line })

local function select(cursor_pos, start_col)
  local ctrl_v = vim.api.nvim_replace_termcodes("<C-v>", true, true, true)
  local ctrl_g = vim.api.nvim_replace_termcodes("<C-g>", true, true, true)
  local key = cursor_pos[2] == start_col and "o" or ""
  vim.api.nvim_feedkeys("gv" .. ctrl_v .. key .. ctrl_g, "nx", false)
end

function left:get_new_line(line_part)
  return line_part.select_text .. line_part.select_text_left_line .. line_part.select_text_right_line
end

function right:get_new_line(line_part, longest)
  local need_blank_count = vim.fn.strdisplaywidth(longest.select_text_right_line) -
      vim.fn.strdisplaywidth(line_part.select_text_right_line)
  if need_blank_count > 0 then
    line_part.select_text_right_line = line_part.select_text_right_line .. string.rep(" ", need_blank_count)
  end
  return line_part.select_text_left_line .. line_part.select_text_right_line .. line_part.select_text
end

function left:get_mark_offset()
  return - #self.line_parts[1].select_text_left_line, - #self.line_parts[#self.line_parts].select_text_left_line
end

function right:get_mark_offset()
  return #self.line_parts[1].select_text_right_line, #self.line_parts[#self.line_parts].select_text_right_line
end

function Line:init(dir, start_row, end_row)
  self.lines = vim.api.nvim_buf_get_lines(0, start_row, end_row, false)
  self.new_lines = {}
  self.line_parts = {}
  self.revise_char_count = 0
  self.line_max_display_width = 0
  self.longest_line_index = nil
  if dir == "left" then
    self.Action = left
  else
    self.Action = right
  end
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

function Line:lines_concat()
  local longest = self.line_parts[self.longest_line_index]

  for _, line_part in ipairs(self.line_parts) do
    local new_line = self.Action:get_new_line(line_part, longest)
    table.insert(self.new_lines, new_line)
  end
end

function Line:find_longest_line(i)
  local line_display_width = vim.fn.strdisplaywidth(self.lines[i])
  if line_display_width > self.line_max_display_width then
    self.line_max_display_width = line_display_width
    self.longest_line_index = i
  end
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
    Line:find_longest_line(i)
  end, function(i)
    Select:revise_select_end_char(i)
    Line:set_line_right_part(i, Select.texts[i])
  end, start_row, start_col, end_row, end_col)

  if Select.balance == false then
    utils.set_visual_mark(start_row, start_col, end_row, end_col)
    select(cursor_pos, start_col)
    return
  end

  Line:lines_concat()
  vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, Line.new_lines)
  local start_col_offset, end_col_offset = Line.Action:get_mark_offset()
  utils.set_visual_mark(start_row, start_col + start_col_offset, end_row, end_col + end_col_offset)
  select(cursor_pos, start_col)
end

return M
