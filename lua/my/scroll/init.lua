--- @class my.scroll
local M = {}

local cursor_follow = true

function M.scroll_up(count)
  count = count or vim.v.count1
  local key = count .. "<C-y>"
  if cursor_follow then
    vim.cmd("normal! " .. vim.keycode(key))
    return
  end
  if vim.fn.line("w0") == 1 then
    return
  end
  vim.cmd("normal! " .. vim.keycode(key .. count .. "k"))
end

function M.scroll_down(count)
  count = count or vim.v.count1
  local key = count .. "<C-e>"
  if cursor_follow then
    vim.cmd("normal! " .. vim.keycode(key))
    return
  end
  if vim.fn.line(".") == vim.fn.line("$") then
    return
  end
  vim.cmd("normal! " .. vim.keycode(key .. count .. "j"))
end

function M.scroll_right()
  local count = vim.v.count1 * 2
  local key = count .. "zh"

  if cursor_follow then
    vim.cmd("normal! " .. key)
    return
  end

  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  if wininfo.leftcol == 0 then
    return
  end
  vim.cmd("normal! " .. key .. count .. "h")
end

function M.scroll_left()
  local count = vim.v.count1 * 2
  local key = count .. "zl"
  if not cursor_follow then
    key = key .. count .. "l"
  end
  vim.cmd("normal! " .. key)
end

return M
