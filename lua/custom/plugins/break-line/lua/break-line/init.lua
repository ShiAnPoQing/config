local M = {}

local Line_break = {}

local function cursor_in_virt_space_fix_cursor(lines, cursor_pos, virtcol)
  local line_display_width = vim.fn.strdisplaywidth(lines[1])
  vim.api.nvim_win_set_cursor(0, cursor_pos)
  vim.api.nvim_feedkeys(virtcol - line_display_width - 1 .. "l", "nx", false)
end

local function is_no_meeting_line_break_condition(cursor_pos, virtcol, lines)
  if cursor_pos[2] + 1 < virtcol then
    cursor_in_virt_space_fix_cursor(lines, cursor_pos, virtcol)
    return true
  end
  if cursor_pos[2] == 0 then
    return true
  end

  return false
end

local function set_curosr(cursor, move)
  vim.api.nvim_win_set_cursor(0, cursor)
  if move == "right" then
    vim.api.nvim_feedkeys("l", "nx", false)
  elseif move == "left" then
    vim.api.nvim_feedkeys("h", "nx", false)
  end
  vim.api.nvim_feedkeys("j", "nx", false)
end

function Line_break:init()
  self.line_break_display_width = nil
end

function Line_break:line_split(line, cursor)
  local line_left = line:sub(1, cursor[2])
  local line_left_display_width = vim.fn.strdisplaywidth(line_left)
  local line_right = vim.fn.strcharpart(line, vim.fn.strcharlen(line_left))

  if self.line_break_display_width == nil then
    self.line_break_display_width = line_left_display_width
  end

  local move
  if line_left_display_width < self.line_break_display_width then
    line_left = line_left .. vim.fn.strcharpart(line_right, 0, 1)
    line_right = vim.fn.strcharpart(line_right, 1)
    move = "right"
  elseif line_left_display_width > self.line_break_display_width then
    line_left = vim.fn.strcharpart(line_left, 0, vim.fn.strcharlen(line_left) - 1)
    line_right = vim.fn.strcharpart(line_left, vim.fn.strcharlen(line_left) - 1) .. line_right
    move = "left"
  end

  return line_left, line_right, move
end

function Line_break:lines_break(lines, cursor_pos)
  for index, line in ipairs(lines) do
    if index > 1 then
      Line_break:line_break(line, vim.api.nvim_win_get_cursor(0))
    else
      Line_break:line_break(line, cursor_pos)
    end
  end
end

function Line_break:line_break(line, cursor)
  if cursor[2] >= #line then
    vim.api.nvim_feedkeys("j", "nx", false)
    return
  end
  local line_left, line_right, move = self:line_split(line, cursor)
  vim.api.nvim_buf_set_lines(0, cursor[1] - 1, cursor[1], false, { line_left, line_right })
  set_curosr(cursor, move)
  self:line_break(line_right, vim.api.nvim_win_get_cursor(0))
end

local function _line_break()
  local mode = vim.api.nvim_get_mode().mode
  local cursor_pos = vim.api.nvim_win_get_cursor(0)
  local virtcol = vim.fn.virtcol(".")
  return function(type)
    if type ~= "line" then
      return
    end
    local start_mark = vim.api.nvim_buf_get_mark(0, "[")
    local end_mark = vim.api.nvim_buf_get_mark(0, "]")
    local lines = vim.api.nvim_buf_get_lines(0, start_mark[1] - 1, end_mark[1], false)
    if is_no_meeting_line_break_condition(cursor_pos, virtcol, lines) then
      return
    end
    Line_break:init()
    Line_break:lines_break(lines, cursor_pos)
  end
end

function M.break_line(count)
  _G.custom_line_break = _line_break()
  vim.opt.operatorfunc = "v:lua.custom_line_break"
  vim.api.nvim_feedkeys("g@", "n", false)
end

function M.setup() end

return M
