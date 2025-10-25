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

return M
