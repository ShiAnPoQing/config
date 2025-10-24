local M = {}

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

local function get_cursor_row()
  local cursor_row = unpack(vim.api.nvim_win_get_cursor(0))
  return cursor_row
end

local function on_key(count, key)
  local c = vim.fn.getchar()
  ---@diagnostic disable-next-line: param-type-mismatch
  local char = vim.fn.nr2char(c)
  if char == "j" then
    vim.api.nvim_feedkeys(count .. "j" .. key, "nx", false)
  elseif char == "k" then
    vim.api.nvim_feedkeys(count .. "k" .. key, "nx", false)
  end
end

local function get_win_info()
  return vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
end

local function get_screen_col(LR, up_line_start, down_line_start)
  local wininfo = get_win_info()
  local up_line = vim.api.nvim_buf_get_lines(0, up_line_start, up_line_start + 1, false)[1]
  local down_line = vim.api.nvim_buf_get_lines(0, down_line_start, down_line_start + 1, false)[1]
  ---@diagnostic disable-next-line: undefined-field
  local leftcol = wininfo.leftcol
  local up_col
  local down_col

  if LR == "left" then
    ---@diagnostic disable-next-line: undefined-field
    local screen_up_line = up_line:sub(leftcol + 1)
    ---@diagnostic disable-next-line: undefined-field
    local screen_down_line = down_line:sub(leftcol + 1)
    local pattern = vim.regex("^\\s*\\S")
    local _, up_end = pattern:match_str(screen_up_line and screen_up_line or "")
    local _, down_end = pattern:match_str(screen_down_line and screen_down_line or "")
    up_end = up_end and up_end - 1 or 0
    down_end = down_end and down_end - 1 or 0
    return math.max(up_end, 0), math.max(down_end, 0)
  else
    local width = wininfo.width - wininfo.textoff
    local screen_up_line = up_line:sub(leftcol + 1, leftcol + width)
    local screen_down_line = down_line:sub(leftcol + 1, leftcol + width)
    local pattern = vim.regex("\\S\\s*$")
    local up_start, _ = pattern:match_str(screen_up_line)
    local down_start, _ = pattern:match_str(screen_down_line)
    local up_text = screen_up_line:sub(0, up_start + 1)
    local down_text = screen_down_line:sub(0, down_start + 1)
    local up_display = vim.fn.strdisplaywidth(up_text) - 1
    local down_display = vim.fn.strdisplaywidth(down_text) - 1
    up_col = up_display
    down_col = down_display

    if up_col >= width then
      up_col = width - 1
    end
    if down_col >= width then
      down_col = width - 1
    end

    return math.max(up_col, 0), math.max(down_col, 0)
  end
end

function M.first_non_blank_character()
  local count = vim.v.count

  if count == 0 then
    local before_cursor = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_feedkeys("g^", "nx", false)
    local after_cursor = vim.api.nvim_win_get_cursor(0)
    if before_cursor[2] == after_cursor[2] then
      vim.api.nvim_feedkeys("g0", "nx", false)
    end
    return
  end

  local cursor_row = get_cursor_row()
  local up_line_start = cursor_row - count - 1
  local down_line_start = cursor_row + count - 1
  local up_col, down_col = get_screen_col("left", up_line_start, down_line_start)
  local clear = set_extmark(up_col, down_col, up_line_start, down_line_start)
  on_key(count, "g^")
  clear()
end

function M.last_non_blank_character()
  local count = vim.v.count
  if count == 0 then
    local before_cursor = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_feedkeys("g" .. vim.api.nvim_replace_termcodes("<end>", true, false, true), "nx", false)
    local after_cursor = vim.api.nvim_win_get_cursor(0)
    if before_cursor[2] == after_cursor[2] then
      vim.api.nvim_feedkeys("g$", "nx", false)
    end
    return
  end

  local cursor_row = get_cursor_row()
  local up_line_start = cursor_row - count - 1
  local down_line_start = cursor_row + count - 1
  local up_col, down_col = get_screen_col("right", up_line_start, down_line_start)
  local clear = set_extmark(up_col, down_col, up_line_start, down_line_start)
  on_key(count, "g" .. vim.api.nvim_replace_termcodes("<end>", true, false, true))
  clear()
end

function M.first_character() end

function M.last_character() end

return M
