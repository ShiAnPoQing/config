local utils = require("utils.mark")

local M = {}
local Dir = {
  LEFT = "left",
  RIGHT = "right"
}

local Line = {}
local Text = {}

local function select()
  vim.api.nvim_feedkeys("gv" .. vim.api.nvim_replace_termcodes("<C-v><C-g>", true, true, true), "nx", false)
end

local left = setmetatable({}, { __index = Line })
local right = setmetatable({}, { __index = Line })

function left:get_char()

end

-- function right:get_char()
--   local char;
--
--   if self.dir == Dir.RIGHT then
--     local char = vim.fn.strcharpart(source_line, 0, col)
--   else
--     char = vim.fn.strcharpart(source_line, vim.fn.strcharlen(source_line) - col)
--   end
-- end

function Line:init(dir, start_row, end_row)
  self.lines = vim.api.nvim_buf_get_lines(0, start_row, end_row, false)
  self.line_parts = {}
  self.new_lines = {}
  self.char_display_width = 0
  self.revise_char_count = 0
  self.stop = nil
  self.dir = dir
  self.Action = self.Action
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
    if self.dir == Dir.RIGHT then
      self:revise_char(1, part.select_text_right_line, part)
    else
      self:revise_char(1, part.select_text_left_line, part)
    end
  end

  if self.revise_char_count < #self.line_parts then
    self:revise_chars()
  end
end

function Line:revise_char(col, source_line, line_part)
  local char;

  if self.dir == Dir.RIGHT then
    char = vim.fn.strcharpart(source_line, 0, col)
  else
    char = vim.fn.strcharpart(source_line, vim.fn.strcharlen(source_line) - col)
  end

  if vim.fn.strcharlen(char) < col and self.revise_char_count ~= #self.line_parts then
    self.stop = true
    return
  end

  local char_display_width = vim.fn.strdisplaywidth(char)
  if char_display_width > self.char_display_width then
    self.char_display_width = char_display_width
    line_part.char = char
  elseif char_display_width == self.char_display_width then
    line_part.char = char
    self.revise_char_count = self.revise_char_count + 1
  elseif char_display_width < self.char_display_width then
    self:revise_char(col + 1, source_line, line_part)
  end
end

function Line:line_concat()
  if self.stop == true then return end

  for _, part in ipairs(self.line_parts) do
    local new_line
    if self.dir == Dir.RIGHT then
      new_line = part.select_text_left_line ..
          part.char .. part.select_text .. vim.fn.strcharpart(part.select_text_right_line, vim.fn.strcharlen(part.char))
    else
      local select_text_left_line_char_len = vim.fn.strcharlen(part.select_text_left_line)
      local char_len = vim.fn.strcharlen(part.char)
      new_line = vim.fn.strcharpart(part.select_text_left_line, 0, select_text_left_line_char_len - char_len) ..
          part.select_text .. part.char .. part.select_text_right_line
    end

    table.insert(self.new_lines, new_line)
  end
end

function Line:merger_lines()
  self:revise_chars()
  self:line_concat()
end

function Line:set_lines(start_row, start_col, end_row, end_col)
  if self.stop == true then
    utils.set_visual_mark(start_row, start_col, end_row, end_col)
    select()
    return
  end

  vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, self.new_lines)

  if self.dir == Dir.RIGHT then
    utils.set_visual_mark(start_row, start_col + #self.line_parts[1].char, end_row,
      end_col + #self.line_parts[#self.line_parts].char)
    select()
  else
    utils.set_visual_mark(start_row, start_col - #self.line_parts[1].char, end_row,
      end_col - #self.line_parts[#self.line_parts].char)
    select()
  end
end

function Text:init()
  self.texts = vim.split(vim.fn.getreg('"'), "\n")
  self.text_display_width = nil
end

function Text:revise_start(callback, start_row, start_col)
  vim.api.nvim_win_set_cursor(0, { start_row, start_col })
  vim.api.nvim_feedkeys("k", "nx", false)
  for i = 1, #self.texts do
    local text = self.texts[i]
    vim.api.nvim_feedkeys("jvy", "nx", false)
    local real_first_char = vim.fn.getreg('"')
    self.texts[i] = real_first_char .. vim.fn.strcharpart(text, 1)
    callback(i, vim.api.nvim_win_get_cursor(0)[2])
  end
end

function Text:revise_end(callback, end_row, end_col)
  vim.api.nvim_win_set_cursor(0, { end_row, end_col })
  vim.api.nvim_feedkeys("j", "nx", false)
  local end_poss = {}
  for i = 1, #self.texts do
    vim.api.nvim_feedkeys("k", "nx", false)
    table.insert(end_poss, 1, vim.api.nvim_win_get_cursor(0))
  end

  for i = 1, #self.texts do
    local text = self.texts[i]
    vim.api.nvim_win_set_cursor(0, end_poss[i])
    vim.api.nvim_feedkeys("vy", "nx", false)
    local real_end_char = vim.fn.getreg('"')
    local select_text = vim.fn.strcharpart(text, 0, vim.fn.strcharlen(text) - 1) .. real_end_char
    self.texts[i] = select_text
    callback(i, select_text)
    self:check_balance(select_text)
  end
end

function Text:check_balance(select_text)
  if self.text_display_width ~= nil then
    if self.text_display_width ~= vim.fn.strdisplaywidth(select_text) then
      Line.stop = true
    end
  else
    self.text_display_width = vim.fn.strdisplaywidth(select_text)
  end
end

--- @param dir "left"|"right"
local function select_block_mode_move(dir)
  vim.api.nvim_exec2([[execute "normal! \<C-g>y"]], {})
  local start_row, start_col, end_row, end_col = utils.get_visual_mark(true)
  Text:init()
  Line:init(dir, start_row - 1, end_row)
  Text:revise_start(function(i, col)
    Line:set_line_left_part(i, col)
  end, start_row, start_col)
  Text:revise_end(function(i, select_text)
    Line:set_line_right_part(i, select_text)
  end, end_row, end_col)
  Line:merger_lines()
  Line:set_lines(start_row, start_col, end_row, end_col)
end

--- @param dir "left"|"right"
function M.select_move(dir)
  local mode = vim.api.nvim_get_mode().mode

  if mode == "s" then
    -- select_mode_move(dir)
  elseif mode == "" then
    select_block_mode_move(dir)
  end
end

return M
