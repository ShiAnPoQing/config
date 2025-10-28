local M = {}
local cursor_follow

--- @param dir "up" | "down" | "left" | "right"
function M.toggle_cursor_follow(dir)
  cursor_follow = not cursor_follow
  if dir == "up" then
    M.scroll_up()
  elseif dir == "down" then
    M.scroll_down()
  elseif dir == "left" then
    M.scroll_left()
  elseif dir == "right" then
    M.scroll_right()
  end
end

function M.scroll_down()
  local count = vim.v.count1
  local key = count .. vim.api.nvim_replace_termcodes("<C-y>", true, false, true)
  if not cursor_follow then
    vim.api.nvim_feedkeys(key, "n", false)
    return
  end
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  if wininfo.topline == 1 then
    return
  end
  vim.api.nvim_feedkeys(key .. count .. "k", "n", false)
end

function M.scroll_up()
  local count = vim.v.count1
  local key = count .. vim.api.nvim_replace_termcodes("<C-e>", true, false, true)
  if not cursor_follow then
    vim.api.nvim_feedkeys(key, "n", false)
    return
  end
  if vim.fn.line(".") == vim.fn.line("$") then
    return
  end
  vim.api.nvim_feedkeys(key .. count .. "j", "n", false)
end

function M.scroll_left()
  local count = vim.v.count1 * 2
  local key = count .. "zl"
  if cursor_follow then
    key = key .. count .. "l"
  end
  vim.api.nvim_feedkeys(key, "n", false)
end

function M.scroll_right()
  local count = vim.v.count1 * 2
  local key = count .. "zh"

  if not cursor_follow then
    vim.api.nvim_feedkeys(key, "n", false)
    return
  end
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  ---@diagnostic disable-next-line: undefined-field
  if wininfo.leftcol == 0 then
    return
  end
  key = key .. count .. "h"
  vim.api.nvim_feedkeys(key, "n", false)
end

local function get_win_info()
  return vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
end

local function get_virt_col_relative_screen_left()
  local virt_col = vim.fn.virtcol(".")
  local wininfo = get_win_info()
  ---@diagnostic disable-next-line: undefined-field
  local leftcol = wininfo.leftcol
  local offset = virt_col - leftcol - 1

  return offset
end

local function get_virt_col_relative_screen_right()
  local virt_col = vim.fn.virtcol(".")
  local wininfo = get_win_info()
  ---@diagnostic disable-next-line: undefined-field
  local leftcol = wininfo.leftcol
  local width = wininfo.width - wininfo.textoff
  local offset = width - (virt_col - leftcol)

  return offset
end

function M.scroll_forward_one_page()
  local count = vim.v.count1
  local wininfo = get_win_info()
  ---@diagnostic disable-next-line: undefined-field
  local height = wininfo.height - vim.opt.cmdheight:get()
  local botline = wininfo.botline
  local topline = wininfo.topline
  local cursor = vim.api.nvim_win_get_cursor(0)

  local relative = botline - cursor[1]
  if botline - topline < height then
    relative = height + topline - cursor[1]
  end

  local fixed
  if relative == 0 then
    fixed = ""
  else
    fixed = relative .. "k"
  end
  vim.api.nvim_feedkeys(count .. vim.api.nvim_replace_termcodes("<C-b>", true, false, true) .. fixed, "nx", false)
end

function M.scroll_backward_one_page()
  local count = vim.v.count1
  local wininfo = get_win_info()
  local topline = wininfo.topline
  local cursor = vim.api.nvim_win_get_cursor(0)
  local relative = cursor[1] - topline

  local fixed
  if relative == 0 then
    fixed = ""
  else
    fixed = relative .. "j"
  end
  vim.api.nvim_feedkeys(count .. vim.api.nvim_replace_termcodes("<C-f>", true, false, true) .. fixed, "nx", false)
end

function M.scroll_half_screen_right()
  local offset = get_virt_col_relative_screen_left()
  local key = "zLg0"
  if offset > 0 then
    key = key .. offset .. "l"
  end
  return key
end

function M.scroll_half_screen_right_i_mode()
  vim.cmd.stopinsert()
  local offset = get_virt_col_relative_screen_left()
  vim.api.nvim_feedkeys("zLg0" .. offset .. "li", "n", false)
end

function M.scroll_half_screen_left()
  local offset = get_virt_col_relative_screen_right()
  local key = "zHg$"
  if offset > 0 then
    key = key .. offset .. "h"
  end
  return key
end

function M.scroll_half_screen_left_i_mode()
  vim.cmd.stopinsert()
  local offset = get_virt_col_relative_screen_right()
  vim.api.nvim_feedkeys("zHg$" .. offset .. "hi", "n", false)
end

return M
