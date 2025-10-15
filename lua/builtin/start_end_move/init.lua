local M = {}

local function get_win_info()
  return vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
end

local function get_cursor_row()
  local cursor_row = unpack(vim.api.nvim_win_get_cursor(0))
  return cursor_row
end

local function on_key(count, key)
  local c = vim.fn.getchar()
  local char = vim.fn.nr2char(c)
  if char == "j" then
    vim.api.nvim_feedkeys(count .. "j" .. key, "nx", false)
  elseif char == "k" then
    vim.api.nvim_feedkeys(count .. "k" .. key, "nx", false)
  end
end

local function set_extmark(up_col, down_col, up_line, down_line)
  local ns_id = vim.api.nvim_create_namespace("test")
  vim.api.nvim_buf_set_extmark(0, ns_id, up_line, 0, {
    virt_text = { { "k", "Operator" } },
    virt_text_win_col = up_col,
  })
  vim.api.nvim_buf_set_extmark(0, ns_id, down_line, 0, {
    virt_text = { { "j", "Operator" } },
    virt_text_win_col = down_col,
  })
  vim.cmd.redraw()

  return function()
    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
  end
end

local function get_screen_col(LR, up_line_start, down_line_start)
  local wininfo = get_win_info()
  local leftcol = wininfo.leftcol
  local up_line = vim.api.nvim_buf_get_lines(0, up_line_start, up_line_start + 1, false)[1]
  local down_line = vim.api.nvim_buf_get_lines(0, down_line_start, down_line_start + 1, false)[1]

  if LR == "left" then
    local pattern = vim.regex("^\\s*\\S")
    local _, up_end = pattern:match_str(up_line and up_line or "")
    local _, down_end = pattern:match_str(down_line and down_line or "")
    up_end = up_end and up_end - leftcol - 1 or 0 - leftcol - 1
    down_end = down_end and down_end - leftcol - 1 or 0 - leftcol - 1
    return math.max(up_end, 0), math.max(down_end, 0)
  else
    local width = wininfo.width - wininfo.textoff
    local pattern = vim.regex("\\S\\s*$")
    local up_start, _ = pattern:match_str(up_line and up_line or "")
    local down_start, _ = pattern:match_str(down_line and down_line or "")
    local up_text = up_line:sub(0, up_start + 1)
    local down_text = down_line:sub(0, down_start + 1)
    local up_display = vim.fn.strdisplaywidth(up_text) - 1
    local down_display = vim.fn.strdisplaywidth(down_text) - 1

    up_start = up_start and up_display - leftcol or 0 - leftcol
    down_start = down_start and down_display - leftcol or 0 - leftcol

    if up_start >= width then
      up_start = width - 1
    end
    if down_start >= width then
      down_start = width - 1
    end
    return math.max(up_start, 0), math.max(down_start, 0)
  end
end

function M.first_non_blank_character()
  local count = vim.v.count

  if count == 0 then
    local cursor1 = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_feedkeys("^", "nx", false)
    local cursor2 = vim.api.nvim_win_get_cursor(0)
    if cursor1[2] == cursor2[2] then
      vim.api.nvim_feedkeys("0", "nx", false)
    end
    return
  end
  local cursor_row = get_cursor_row()
  local up_line_start = cursor_row - count - 1
  local down_line_start = cursor_row + count - 1
  local up_col, down_col = get_screen_col("left", up_line_start, down_line_start)
  local clear = set_extmark(up_col, down_col, up_line_start, down_line_start)
  on_key(count, "^")
  clear()
end

function M.last_non_blank_character()
  local count = vim.v.count

  if count == 0 then
    local cursor1 = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_feedkeys(count .. "g_", "nx", false)
    local cursor2 = vim.api.nvim_win_get_cursor(0)
    if cursor1[2] == cursor2[2] then
      vim.api.nvim_feedkeys("$", "nx", false)
    end
    return
  end

  local cursor_row = get_cursor_row()
  local up_line_start = cursor_row - count - 1
  local down_line_start = cursor_row + count - 1
  local up_col, down_col = get_virt_col("right", up_line_start, down_line_start)
  local clear = set_extmark(up_col, down_col, up_line_start, down_line_start)
  on_key(count, "g_")
  clear()
end

function M.first_character()
  local count = vim.v.count
  if count == 0 then
    vim.api.nvim_feedkeys("0", "n", false)
    return
  end

  local wininfo = get_win_info()
  local leftcol = wininfo.leftcol
  local cursor_row = get_cursor_row()
  local up_line_start = cursor_row - count - 1
  local down_line_start = cursor_row + count - 1
  local clear = set_extmark(0 - leftcol, 0 - leftcol, up_line_start, down_line_start)
  on_key(count, "0")
  clear()
end

function M.last_character()
  local count = vim.v.count
  if count == 0 then
    vim.api.nvim_feedkeys("$", "n", false)
    return
  end

  local cursor_row = get_cursor_row()
  local up_line_start = cursor_row - count - 1
  local down_line_start = cursor_row + count - 1
  local up_line = vim.api.nvim_buf_get_lines(0, up_line_start, up_line_start + 1, false)[1]
  local down_line = vim.api.nvim_buf_get_lines(0, down_line_start, down_line_start + 1, false)[1]

  local wininfo = get_win_info()
  local leftcol = wininfo.leftcol
  local width = wininfo.width - wininfo.textoff
  local up_col = vim.fn.strdisplaywidth(up_line) - leftcol
  local down_col = vim.fn.strdisplaywidth(down_line) - leftcol

  if up_col >= width then
    up_col = width - 1
  end

  if down_col >= width then
    down_col = width - 1
  end

  local clear = set_extmark(up_col, down_col, up_line_start, down_line_start)
  on_key(count, "$")
  clear()
end

return M
