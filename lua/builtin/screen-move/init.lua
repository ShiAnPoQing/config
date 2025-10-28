local M = {}

function M.first_non_blank_character()
  vim.api.nvim_feedkeys("g^", "nx", false)
end

function M.first_character()
  vim.api.nvim_feedkeys("g0", "nx", false)
end

function M.last_character()
  vim.api.nvim_feedkeys("g$", "nx", false)
end

function M.screen_top()
  local line = vim.fn.line(".")
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local topline = wininfo.topline

  if line == topline then
    vim.api.nvim_feedkeys("zbH", "nx", false)
  else
    vim.api.nvim_feedkeys("H", "nx", false)
  end
end

function M.screen_bottom()
  local line = vim.fn.line(".")
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local botline = wininfo.botline

  if line == botline then
    vim.api.nvim_feedkeys("ztL", "nx", false)
  else
    vim.api.nvim_feedkeys("L", "nx", false)
  end
end

function M.last_non_blank_character()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("g<end>", true, false, true), "nx", false)
end

function M.screen_left()
  local cursor1 = vim.api.nvim_win_get_cursor(0)
  M.first_non_blank_character()
  local cursor2 = vim.api.nvim_win_get_cursor(0)
  if cursor1[2] > cursor2[2] then
    return
  end
  vim.api.nvim_win_set_cursor(0, cursor1)
  M.first_character()
  local cursor3 = vim.api.nvim_win_get_cursor(0)
  if cursor1[2] == cursor3[2] then
    vim.api.nvim_feedkeys("zeg^", "nx", false)
  end
end

function M.screen_right()
  ---@diagnostic disable-next-line: undefined-field
  local virtualedit = vim.opt.virtualedit:get()[1]
  local cursor1 = vim.api.nvim_win_get_cursor(0)
  vim.opt_local.virtualedit = "none"
  M.last_non_blank_character()
  vim.opt_local.virtualedit = virtualedit
  local cursor2 = vim.api.nvim_win_get_cursor(0)
  if cursor1[2] < cursor2[2] then
    return
  end

  vim.api.nvim_win_set_cursor(0, cursor1)
  M.last_character()
  local cursor3 = vim.api.nvim_win_get_cursor(0)
  if cursor1[2] ~= cursor3[2] then
    return
  end

  if virtualedit == "all" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("zsg<end>", true, false, true), "nx", false)
  elseif virtualedit == "none" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("g<end>", true, false, true), "nx", false)
  end
end

return M
