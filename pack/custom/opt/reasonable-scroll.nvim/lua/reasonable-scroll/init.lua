local M = {}

local function feedkeys(keys)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(keys, true, false, true), "nx", false)
end

local function fix_winline(win_line, fix)
  local new_win_line = vim.fn.winline()
  if new_win_line == win_line then
    return
  end
  feedkeys(math.abs(win_line - new_win_line) .. fix)
end

local function get_win_info()
  return vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
end

local function get_virt_win_col()
  local virt_col = vim.fn.virtcol(".")
  local wininfo = get_win_info()
  return virt_col - wininfo.leftcol - 1
end

function M.scroll_page_up()
  local win_line = vim.fn.winline()
  local relative = vim.fn.winheight(0) - win_line
  local fixed = relative == 0 and "" or relative .. "k"
  local key = vim.v.count1 .. "<C-b>" .. fixed
  feedkeys(key)
  fix_winline(win_line, "j")
end

function M.scroll_page_down()
  if vim.fn.line("w$") == vim.fn.line("$") then
    return
  end
  local win_line = vim.fn.winline()
  local relative = win_line - 1
  local fixed = relative == 0 and "" or relative .. "j"
  local key = vim.v.count1 .. "<C-f>" .. fixed
  feedkeys(key)
  fix_winline(win_line, "<C-y>")
end

function M.scroll_half_page_left()
  local virt_win_col = get_virt_win_col()
  local key = "zHg0"
  if virt_win_col > 0 then
    key = key .. virt_win_col .. "l"
  end
  feedkeys(key)
end

function M.scroll_half_page_right()
  local virt_win_col = get_virt_win_col()
  local key = "zLg0"
  if virt_win_col > 0 then
    key = key .. virt_win_col .. "l"
  end
  feedkeys(key)
end

function M.i_scroll_half_page_left()
  vim.cmd.stopinsert()
  vim.schedule(function()
    M.scroll_half_page_left()
    vim.api.nvim_feedkeys("a", "n", false)
  end)
end

function M.i_scroll_half_page_right()
  vim.cmd.stopinsert()
  vim.schedule(function()
    M.scroll_half_page_right()
    vim.api.nvim_feedkeys("a", "n", false)
  end)
end

function M.i_scroll_page_up()
  vim.cmd.stopinsert()
  vim.schedule(function()
    M.scroll_page_up()
    vim.api.nvim_feedkeys("a", "n", false)
  end)
end

function M.i_scroll_page_down()
  vim.cmd.stopinsert()
  vim.schedule(function()
    M.scroll_page_down()
    vim.api.nvim_feedkeys("a", "n", false)
  end)
end

return M
