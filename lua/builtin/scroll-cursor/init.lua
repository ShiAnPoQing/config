local M = {}

function M.scroll_left()
  local virt_col = vim.fn.virtcol(".")
  local line = vim.api.nvim_get_current_line()
  local display_width = vim.fn.strdisplaywidth(line)
  if virt_col <= display_width then
    return "zs"
  else
    local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
    ---@diagnostic disable-next-line: undefined-field
    local leftcol = wininfo.leftcol
    if virt_col - leftcol > 1 then
      return (virt_col - leftcol - 1) .. "zl"
    end
  end
end

function M.scroll_right()
  local virt_col = vim.fn.virtcol(".")
  local line = vim.api.nvim_get_current_line()
  local display_width = vim.fn.strdisplaywidth(line)
  if virt_col <= display_width then
    return "ze"
  else
    local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
    local width = wininfo.width - wininfo.textoff
    ---@diagnostic disable-next-line: undefined-field
    local leftcol = wininfo.leftcol
    local win_virt_col = virt_col - leftcol
    local count = width - win_virt_col
    if count > 0 then
      return count .. "zh"
    end
  end
end

function M.scroll_up()
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local topline = wininfo.topline
  local line = vim.fn.line(".")
  if topline == line then
    return "<C-f>zt"
  else
    return "zt"
  end
end

function M.scroll_down()
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local botline = wininfo.botline
  local line = vim.fn.line(".")
  if botline == line then
    return "<C-b>zb"
  else
    return "zb"
  end
end

function M.scroll_row_center()
  local win_info = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local screen_width = win_info.width - win_info.textoff
  ---@diagnostic disable-next-line: undefined-field
  local leftcol = win_info.leftcol
  local screent_cursor_rol = vim.fn.virtcol(".") - leftcol
  local offset = math.ceil(screen_width / 2) - screent_cursor_rol + 1

  if offset > 0 then
    return offset .. "zh"
  elseif offset < 0 then
    return -offset .. "zl"
  end
end

return M
