local U = require("reasonable-scroll.util")
local M = {}

local cursor_follow = true

local function toggle_cursor_follow()
  cursor_follow = not cursor_follow
end

function M.scroll_up(count)
  count = count or vim.v.count1
  local key = count .. "<C-y>"
  if cursor_follow then
    U.feedkeys(key)
    return
  end
  if vim.fn.line("w0") == 1 then
    return
  end
  U.feedkeys(key .. count .. "k")
end

function M.scroll_down(count)
  count = count or vim.v.count1
  local key = count .. "<C-e>"
  if cursor_follow then
    U.feedkeys(key)
    return
  end
  if vim.fn.line(".") == vim.fn.line("$") then
    return
  end
  U.feedkeys(key .. count .. "j")
end

function M.scroll_left()
  local count = vim.v.count1 * 2
  local key = count .. "zl"
  if not cursor_follow then
    key = key .. count .. "l"
  end
  U.feedkeys(key)
end

function M.scroll_right()
  local count = vim.v.count1 * 2
  local key = count .. "zh"

  if cursor_follow then
    U.feedkeys(key)
    return
  end
  local wininfo = U.get_wininfo()
  if wininfo.leftcol == 0 then
    return
  end
  key = key .. count .. "h"
  U.feedkeys(key)
end

function M.toggle_scroll_up()
  toggle_cursor_follow()
  M.scroll_up()
end

function M.toggle_scroll_down()
  toggle_cursor_follow()
  M.scroll_down()
end

function M.toggle_scroll_left()
  toggle_cursor_follow()
  M.scroll_left()
end

function M.toggle_scroll_right()
  toggle_cursor_follow()
  M.scroll_right()
end

return M
