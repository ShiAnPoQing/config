--- @class my.scroll
local M = {}

--- @param count? integer
function M.up(count)
  count = count or vim.v.count1
  local key = count .. "<C-y>"
  if not my.wo.scroll_only then
    vim.cmd("normal! " .. vim.keycode(key))
    return
  end
  if vim.fn.line("w0") == 1 then
    return
  end
  vim.cmd("normal! " .. vim.keycode(key .. count .. "k"))
end

--- @param count? integer
function M.down(count)
  count = count or vim.v.count1
  local key = count .. "<C-e>"
  if not my.wo.scroll_only then
    vim.cmd("normal! " .. vim.keycode(key))
    return
  end
  if vim.fn.line(".") == vim.fn.line("$") then
    return
  end
  vim.cmd("normal! " .. vim.keycode(key .. count .. "j"))
end

function M.right()
  local mode = vim.api.nvim_get_mode().mode
  local count = vim.v.count1 * 2
  local key = count .. "zh"

  if not my.wo.scroll_only then
    if mode == "i" then
      local cursor = vim.api.nvim_win_get_cursor(0)
      vim.cmd("normal! " .. key .. vim.keycode("<Ignore>"))
      vim.api.nvim_win_set_cursor(0, cursor)
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
end

function M.left()
  local mode = vim.api.nvim_get_mode().mode
  local count = vim.v.count1 * 2
  local key = count .. "zl"
  if not my.wo.scroll_only then
    if mode == "i" then
      local cur = vim.api.nvim_win_get_cursor(0)
      vim.cmd("normal! " .. key .. vim.keycode("<Ignore>"))
      vim.api.nvim_win_set_cursor(0, cur)
    else
      vim.cmd("normal! " .. key)
    end
    return
  end
  key = key .. count .. "l"
  vim.cmd("normal! " .. key)
end

local function get_scroll_page_down_view()
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local endline = vim.fn.line("$")
  if endline == wininfo.botline then
    return
  end
  local line = vim.fn.line(".")
  local scroll_line_count = math.min(vim.v.count1 * wininfo.height, endline - line)
  local view = vim.fn.winsaveview()
  view.topline = view.topline + scroll_line_count
  view.lnum = view.lnum + scroll_line_count
  view.col = view.curswant
  return view
end

local function get_scroll_page_up_view()
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  if wininfo.topline == 1 then
    return
  end
  local scroll_line_count = math.min(vim.v.count1 * wininfo.height, wininfo.topline - 1)
  local view = vim.fn.winsaveview()
  view.topline = view.topline - scroll_line_count
  view.lnum = view.lnum - scroll_line_count
  view.col = view.curswant
  return view
end

function M.page_down()
  local view = get_scroll_page_down_view()
  if not view then
    return
  end
  vim.fn.winrestview(view)
end

function M.page_up()
  local view = get_scroll_page_up_view()
  if not view then
    return
  end
  vim.fn.winrestview(view)
end

local function fix_insert_mode_view(view)
  local line = vim.fn.line(".")
  local move = "<up>"
  if line == 1 then
    move = "<down>"
  end
  vim.api.nvim_feedkeys(
    vim.keycode(string.format(move .. "<Cmd>lua vim.fn.winrestview(%s)<cr>", vim.inspect(view):gsub("\n", ""))),
    "n",
    false
  )
end

function M.i_scroll_page_down()
  local view = get_scroll_page_down_view()
  if not view then
    return
  end
  vim.fn.winrestview(view)
  fix_insert_mode_view(view)
end

function M.i_scroll_page_up()
  local view = get_scroll_page_up_view()
  if not view then
    return
  end
  vim.fn.winrestview(view)
  fix_insert_mode_view(view)
end

function M.half_page_down()
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local endline = vim.fn.line("$")
  if endline == wininfo.botline then
    return
  end
  local line = vim.fn.line(".")
  local scroll_line_count = math.min(math.floor((vim.v.count1 * wininfo.height) / 2), endline - line)
  local view = vim.fn.winsaveview()
  view.topline = view.topline + scroll_line_count
  view.lnum = view.lnum + scroll_line_count
  view.col = view.curswant
  vim.fn.winrestview(view)
end

function M.half_page_up()
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  if wininfo.topline == 1 then
    return
  end
  local scroll_line_count = math.min(math.floor((vim.v.count1 * wininfo.height) / 2), wininfo.topline - 1)
  local view = vim.fn.winsaveview()
  view.topline = view.topline - scroll_line_count
  view.lnum = view.lnum - scroll_line_count
  view.col = view.curswant
  vim.fn.winrestview(view)
end

return M
