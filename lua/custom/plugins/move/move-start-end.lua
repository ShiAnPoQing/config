local M = {}

--- @alias LR "left"|"right"

local function on_key(count)
  local char = vim.fn.nr2char(vim.fn.getchar())
  if char == "j" then
    vim.api.nvim_feedkeys(count .. "j^", "nx", false)
  elseif char == "k" then
    vim.api.nvim_feedkeys(count .. "k^", "nx", false)
  end
end

local function set_extmark(up_col, down_col, up_line, down_line)
  local ns_id = vim.api.nvim_create_namespace("test")
  vim.api.nvim_buf_set_extmark(0, ns_id, up_line, 0, {
    virt_text = { { "k", "HopNextKey" } },
    virt_text_win_col = up_col
  })
  vim.api.nvim_buf_set_extmark(0, ns_id, down_line, 0, {
    virt_text = { { "j", "HopNextKey" } },
    virt_text_win_col = down_col
  })
  vim.cmd.redraw()

  return function()
    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
  end
end

--- @param LR LR
local function get_virt_col(LR, up_line_start, down_line_start)
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
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
    up_start = up_start and up_start - leftcol or 0 - leftcol
    down_start = down_start and down_start - leftcol or 0 - leftcol
    if up_start >= width then
      up_start = width
    end
    if down_start >= width then
      down_start = width
    end
    return math.max(up_start, 0), math.max(down_start, 0)
  end
end

--- @param LR LR
function M.move_start_end(LR)
  local count = vim.v.count1

  if LR == "left" then
    if count == 1 then
      local cursor1 = vim.api.nvim_win_get_cursor(0)
      vim.api.nvim_feedkeys("^", "nx", false)
      local cursor2 = vim.api.nvim_win_get_cursor(0)
      if cursor1[2] == cursor2[2] then
        vim.api.nvim_feedkeys("0", "nx", false)
      end
    else
      local cursor_row, _ = unpack(vim.api.nvim_win_get_cursor(0))
      local up_line_start = cursor_row - count - 1
      local down_line_start = cursor_row + count - 1
      local up_col, down_col = get_virt_col(LR, up_line_start, down_line_start)
      local clear = set_extmark(up_col, down_col, up_line_start, down_line_start)
      on_key(count)
      clear()
    end
  else
    if count == 1 then
      local cursor1 = vim.api.nvim_win_get_cursor(0)
      vim.api.nvim_feedkeys(count .. "g_", "nx", false)
      local cursor2 = vim.api.nvim_win_get_cursor(0)
      if cursor1[2] == cursor2[2] then
        vim.api.nvim_feedkeys("$", "nx", false)
      end
    else
      local cursor_row, _ = unpack(vim.api.nvim_win_get_cursor(0))
      local up_line_start = cursor_row - count - 1
      local down_line_start = cursor_row + count - 1
      local up_col, down_col = get_virt_col(LR, up_line_start, down_line_start)
      local clear = set_extmark(up_col, down_col, up_line_start, down_line_start)
      on_key(count)
      clear()
    end
  end
end

return M
