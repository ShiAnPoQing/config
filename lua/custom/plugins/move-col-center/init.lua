local M = {}

local function get_offset(offset, count)
  for i = 1, count do
    offset = (offset - 1) / 2
    if offset % 1 ~= 0 then
      offset = math.floor(offset)
    end
  end

  return offset
end

local function move_revise(offset, text)
  local move = 0
  local next = offset
  while true do
    if vim.fn.strdisplaywidth(vim.fn.strcharpart(text, 0, next)) > offset then
      move = move + 1
      next = next - 1
    else
      break
    end
  end

  return move
end

local function get_screen_text(line_display_width, virtcol_at_screen_right, cursor, line)
  local end_col;
  if line_display_width > virtcol_at_screen_right then
    end_col = vim.api.nvim_win_get_cursor(0)[2]
  else
    end_col = #line
  end
  return vim.api.nvim_buf_get_text(0, cursor[1] - 1, cursor[2], cursor[1] - 1, end_col + 1, {})[1]
end

local function get_screen_left_text(cursor)
  local start_col = vim.api.nvim_win_get_cursor(0)[2]
  local text = vim.api.nvim_buf_get_text(0, cursor[1] - 1, start_col, cursor[1] - 1, cursor[2] + 1, {})[1]
  return text
end

local Action = {}

local left = {}
local right = {}

function left:line_move(offset)
  local text = get_screen_left_text(Action.cursor)

  if offset < vim.fn.strdisplaywidth(text) then
    local move = move_revise(offset, text)
    vim.api.nvim_feedkeys(offset - move .. "l", "nx", false)
    self.remain = 0
  else
    vim.api.nvim_win_set_cursor(0, { Action.cursor[1], #Action.line })
    self.remain = offset - vim.fn.strdisplaywidth(text)
  end
end

function left:get_move_count()
  local viewport_virtcol = Action.virtcol - Action.wininfo.leftcol
  return get_offset(viewport_virtcol, Action.count)
end

function left:virt_move(move_count)
  if self.remain > 0 then
    vim.api.nvim_feedkeys(move_count - self.remain .. "l", "nx", false)
  end
end

function left:move_center()
  local move_count = self:get_move_count()
  vim.api.nvim_feedkeys("g0", "nx", false)
  self:line_move(move_count)
  self:virt_move(move_count)
end

function right:line_move(line_display_width, virtcol_at_screen_right)
  if self.remain > 0 then
    local screen_line_to_end = get_screen_text(line_display_width, virtcol_at_screen_right, Action.cursor, Action.line)
    local text = vim.fn.strcharpart(screen_line_to_end, vim.fn.strcharlen(screen_line_to_end) - self.remain)
    local move = move_revise(self.remain, text)
    vim.api.nvim_feedkeys(self.remain - move .. "h", "nx", false)
  end
end

function right:get_move_count()
  local screen_width = Action.wininfo.width - Action.wininfo.textoff
  local viewport_virtcol = screen_width - (Action.virtcol - Action.wininfo.leftcol)
  return get_offset(viewport_virtcol, Action.count)
end

function right:virt_move(offset, line_display_width, virtcol_at_screen_right)
  if line_display_width >= virtcol_at_screen_right then
    self.remain = offset
    return
  end

  local space = virtcol_at_screen_right - line_display_width

  if offset >= space then
    if space > 0 then
      vim.api.nvim_feedkeys(space .. "h", "nx", false)
    end
    self.remain = offset - space
  else
    if offset > 0 then
      vim.api.nvim_feedkeys(offset .. "h", "nx", false)
    end
    self.remain = 0
  end
end

function right:move_center()
  local move_count = self:get_move_count()
  vim.api.nvim_feedkeys("g$", "nx", false)
  local virtcol_at_screen_right = vim.fn.virtcol(".")
  local line_display_width = vim.fn.strdisplaywidth(Action.line)
  self:virt_move(move_count, line_display_width, virtcol_at_screen_right)
  self:line_move(line_display_width, virtcol_at_screen_right)
end

function Action:init()
  Action.wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  Action.cursor = vim.api.nvim_win_get_cursor(0)
  Action.count = vim.v.count1
  Action.virtcol = vim.fn.virtcol(".")
  Action.line = vim.api.nvim_get_current_line()
  Action.left = left
  Action.right = right
end

--- @param LR "left"|"right"
function M.move_col_center(LR)
  Action:init()
  Action[LR]:move_center()
end

return M
