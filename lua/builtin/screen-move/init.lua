local M = {}

function M.top()
  local line = vim.fn.line(".")
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local topline = wininfo.topline

  if line == topline then
    vim.api.nvim_feedkeys("zbH", "nx", false)
  else
    vim.api.nvim_feedkeys("H", "nx", false)
  end
end

function M.bottom()
  local line = vim.fn.line(".")
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local botline = wininfo.botline

  if line == botline then
    vim.api.nvim_feedkeys("ztL", "nx", false)
  else
    vim.api.nvim_feedkeys("L", "nx", false)
  end
end

function M.first_non_blank_character()
  local cursor1 = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_feedkeys("g^", "nx", false)
  local cursor2 = vim.api.nvim_win_get_cursor(0)
  if cursor1[2] == cursor2[2] then
    vim.api.nvim_feedkeys("g0", "nx", false)
  end
end

function M.last_non_blank_character()
  local cursor1 = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("g<end>", true, false, true), "nx", false)
  local cursor2 = vim.api.nvim_win_get_cursor(0)
  if cursor1[2] == cursor2[2] then
    vim.api.nvim_feedkeys("g$", "nx", false)
  end
end

function M.first_character()
  local cursor1 = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_feedkeys("g0", "nx", false)
  local cursor2 = vim.api.nvim_win_get_cursor(0)
  if cursor1[2] == cursor2[2] then
    vim.api.nvim_feedkeys("zeg^", "nx", false)
  end
end

function M.last_character()
  ---@diagnostic disable-next-line: undefined-field
  local virtualedit = vim.opt.virtualedit:get()[1]
  local cursor1 = vim.api.nvim_win_get_cursor(0)
  vim.api.nvim_feedkeys("g$", "nx", false)
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
