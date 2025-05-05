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

local function get_move_count(LR, virtcol, wininfo, count)
  local viewport_virtcol;
  if LR == "left" then
    viewport_virtcol = virtcol - wininfo.leftcol
  else
    local screen_width = wininfo.width - wininfo.textoff
    viewport_virtcol = screen_width - (virtcol - wininfo.leftcol)
  end

  return get_offset(viewport_virtcol, count)
end

local function virt_move(offset, line_display_width, virtcol_at_screen_right)
  if line_display_width < virtcol_at_screen_right then
    local space = virtcol_at_screen_right - line_display_width

    if offset >= space then
      if space > 0 then
        vim.api.nvim_feedkeys(space .. "h", "nx", false)
      end
      return offset - space
    else
      if offset > 0 then
        vim.api.nvim_feedkeys(offset .. "h", "nx", false)
      end
      return 0
    end
  end

  return offset
end

local function move_revise_left(offset, screen_line_to_end)
  local move = 0
  local text = vim.fn.strcharpart(screen_line_to_end, vim.fn.strcharlen(screen_line_to_end) - offset)
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

local function move_revise_right(offset, text)
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

local function line_move(remain, line_display_width, virtcol_at_screen_right, cursor, line)
  if remain > 0 then
    local text = get_screen_text(line_display_width, virtcol_at_screen_right, cursor, line)
    local move = move_revise_left(remain, text)
    vim.api.nvim_feedkeys(remain - move .. "h", "nx", false)
  end
end

local function get_screen_left_text(cursor)
  local start_col = vim.api.nvim_win_get_cursor(0)[2]
  local text = vim.api.nvim_buf_get_text(0, cursor[1] - 1, start_col, cursor[1] - 1, cursor[2] + 1, {})[1]
  return text
end

local function line_move_right(offset, cursor, line)
  local text = get_screen_left_text(cursor)

  if offset < vim.fn.strdisplaywidth(text) then
    local move = move_revise_right(offset, text)
    vim.api.nvim_feedkeys(offset - move .. "l", "nx", false)
    return 0
  else
    vim.api.nvim_win_set_cursor(0, { cursor[1], #line })
    return offset - vim.fn.strdisplaywidth(text)
  end
end

--- @param LR "left"|"right"
function M.move_col_center(LR)
  local count = vim.v.count1
  local line = vim.api.nvim_get_current_line()
  local virtcol = vim.fn.virtcol(".")
  local cursor = vim.api.nvim_win_get_cursor(0)
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local move_count = get_move_count(LR, virtcol, wininfo, count)

  if LR == "left" then
    vim.api.nvim_feedkeys("g0", "nx", false)
    local remain = line_move_right(move_count, cursor, line)

    if remain > 0 then
      vim.api.nvim_feedkeys(move_count - remain .. "l", "nx", false)
    end
  else
    vim.api.nvim_feedkeys("g$", "nx", false)
    local virtcol_at_screen_right = vim.fn.virtcol(".")
    local line_display_width = vim.fn.strdisplaywidth(line)
    local remain = virt_move(move_count, line_display_width, virtcol_at_screen_right)
    line_move(remain, line_display_width, virtcol_at_screen_right, cursor, line)
  end
end

return M
