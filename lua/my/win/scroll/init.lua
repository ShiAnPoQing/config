--- @class my.win.scroll
local M = {}
local api = vim.api

--- @param win integer
--- @param count integer
function M.down(win, count)
  vim.validate("win", win, "number")
  vim.validate("count", count, "number")
  count = math.floor(count)
  local key = count .. "<C-e>"
  api.nvim_win_call(win, function()
    if not my.wo.scroll_only then
      vim.cmd("normal! " .. vim.keycode(key))
      return
    end
    if vim.fn.line(".") == vim.fn.line("$") then
      return
    end
    vim.cmd("normal! " .. vim.keycode(key .. count .. "j"))
  end)
end

--- @param win integer
--- @param count integer
function M.up(win, count)
  vim.validate("win", win, "number")
  vim.validate("count", count, "number")
  count = math.floor(count)
  local key = count .. "<C-y>"
  api.nvim_win_call(win, function()
    if not my.wo.scroll_only then
      vim.cmd("normal! " .. vim.keycode(key))
      return
    end
    if vim.fn.line("w0") == 1 then
      return
    end
    vim.cmd("normal! " .. vim.keycode(key .. count .. "k"))
  end)
end

--- @param win integer
--- @param count integer
function M.right(win, count)
  vim.validate("win", win, "number")
  vim.validate("count", count, "number")
  count = math.floor(count)
  local key = count .. "zh"
  api.nvim_win_call(win, function()
    local mode = vim.api.nvim_get_mode().mode

    if not my.wo.scroll_only then
      if mode == "i" then
        local cursor = vim.api.nvim_win_get_cursor(win)
        vim.cmd("normal! " .. key .. vim.keycode("<Ignore>"))
        vim.api.nvim_win_set_cursor(win, cursor)
      else
        vim.cmd("normal! " .. key)
      end
      return
    end

    local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
    if wininfo.leftcol == 0 then
      return
    end
    vim.cmd("normal! " .. key .. count .. "h")
  end)
end

--- @param win integer
--- @param count integer
function M.left(win, count)
  vim.validate("win", win, "number")
  vim.validate("count", count, "number")
  count = math.floor(count)
  local key = count .. "zl"
  api.nvim_win_call(win, function()
    local mode = vim.api.nvim_get_mode().mode
    if not my.wo.scroll_only then
      if mode == "i" then
        local cur = vim.api.nvim_win_get_cursor(win)
        vim.cmd("normal! " .. key .. vim.keycode("<Ignore>"))
        vim.api.nvim_win_set_cursor(win, cur)
      else
        vim.cmd("normal! " .. key)
      end
      return
    end
    key = key .. count .. "l"
    vim.cmd("normal! " .. key)
  end)
end

local function get_scroll_page_down_view(count)
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local endline = vim.fn.line("$")
  if endline == wininfo.botline then
    return
  end
  local line = vim.fn.line(".")
  local scroll_line_count = math.min(count * wininfo.height, endline - line)
  local view = vim.fn.winsaveview()
  view.topline = view.topline + scroll_line_count
  view.lnum = view.lnum + scroll_line_count
  view.col = view.curswant
  return view
end

--- @param win integer
--- @param count integer
function M.page_down(win, count)
  vim.validate("win", win, "number")
  vim.validate("count", count, "number")
  count = math.floor(count)
  api.nvim_win_call(win, function()
    local view = get_scroll_page_down_view(count)
    if not view then
      return
    end
    vim.fn.winrestview(view)
  end)
end

local function get_scroll_page_up_view(count)
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  if wininfo.topline == 1 then
    return
  end
  local scroll_line_count = math.min(count * wininfo.height, wininfo.topline - 1)
  local view = vim.fn.winsaveview()
  view.topline = view.topline - scroll_line_count
  view.lnum = view.lnum - scroll_line_count
  view.col = view.curswant
  return view
end

--- @param win integer
--- @param count integer
function M.page_up(win, count)
  vim.validate("win", win, "number")
  vim.validate("count", count, "number")
  count = math.floor(count)
  api.nvim_win_call(win, function()
    local view = get_scroll_page_up_view(count)
    if not view then
      return
    end
    vim.fn.winrestview(view)
  end)
end

--- @param win integer
--- @param count integer
function M.half_page_down(win, count)
  vim.validate("win", win, "number")
  vim.validate("count", count, "number")
  count = math.floor(count)
  api.nvim_win_call(win, function()
    local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
    local endline = vim.fn.line("$")
    if endline == wininfo.botline then
      return
    end
    local line = vim.fn.line(".")
    local scroll_line_count = math.min(math.floor((count * wininfo.height) / 2), endline - line)
    local view = vim.fn.winsaveview()
    view.topline = view.topline + scroll_line_count
    view.lnum = view.lnum + scroll_line_count
    view.col = view.curswant
    vim.fn.winrestview(view)
  end)
end

--- @param win integer
--- @param count integer
function M.half_page_up(win, count)
  vim.validate("win", win, "number")
  vim.validate("count", count, "number")
  count = math.floor(count)
  api.nvim_win_call(win, function()
    local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
    if wininfo.topline == 1 then
      return
    end
    local scroll_line_count = math.min(math.floor((count * wininfo.height) / 2), wininfo.topline - 1)
    local view = vim.fn.winsaveview()
    view.topline = view.topline - scroll_line_count
    view.lnum = view.lnum - scroll_line_count
    view.col = view.curswant
    vim.fn.winrestview(view)
  end)
end

return M
