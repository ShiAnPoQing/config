local U = require("reasonable-scroll.util")
local M = {}

local function fix_winline(win_line, fix)
  local new_win_line = vim.fn.winline()
  if new_win_line == win_line then
    return
  end
  U.feedkeys(math.abs(win_line - new_win_line) .. fix)
end

local function get_virt_win_col()
  local virt_col = vim.fn.virtcol(".")
  local wininfo = U.get_wininfo()
  return virt_col - wininfo.leftcol - 1
end

function M.scroll_page_up(count)
  count = count or vim.v.count1
  local win_line = vim.fn.winline()
  local scrolloff = U.get_scrolloff()
  local relative = vim.fn.winheight(0) - win_line - scrolloff
  local fixed
  if relative <= 0 then
    fixed = ""
  else
    fixed = relative .. "k"
  end
  U.feedkeys(count .. "<C-b>" .. fixed)
  fix_winline(win_line, "j")
end

function M.scroll_page_down(count)
  if vim.fn.line("w$") == vim.fn.line("$") then
    return
  end
  count = count or vim.v.count1
  local scrolloff = U.get_scrolloff()
  local win_line = vim.fn.winline()
  local relative = win_line - 1 - scrolloff
  local fixed
  if relative <= 0 then
    fixed = ""
  else
    fixed = relative .. "j"
  end
  U.feedkeys(count .. "<C-f>" .. fixed)
  fix_winline(win_line, "<C-y>")
end

function M.scroll_half_page_left()
  local virt_win_col = get_virt_win_col()
  local key = "zHg0"
  if virt_win_col > 0 then
    key = key .. virt_win_col .. "l"
  end
  U.feedkeys(key)
end

function M.scroll_half_page_right()
  local virt_win_col = get_virt_win_col()
  local key = "zLg0"
  if virt_win_col > 0 then
    key = key .. virt_win_col .. "l"
  end
  U.feedkeys(key)
end

return M
