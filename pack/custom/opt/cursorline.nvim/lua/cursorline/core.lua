--[[
        Command          global value    local value         condition ~
      :set option=value      set            set
 :setlocal option=value       -             set
:setglobal option=value      set             -
      :set option?            -           display     local value is set
      :set option?         display           -        local value is not set
 :setlocal option?            -           display
:setglobal option?         display           -
--]]

--- @class Cursorline
local M = {}

local function reset_cursorline()
  local tabs = vim.api.nvim_list_tabpages()
  for _, tab in ipairs(tabs) do
    local wins = vim.api.nvim_tabpage_list_wins(tab)
    for _, win in ipairs(wins) do
      vim.api.nvim_set_option_value("cursorline", false, { win = win })
    end
  end
end

function M:is_active()
  return self.win_enter and self.win_leave
end

function M:active()
  vim.opt.cursorline = true
  vim.opt_local.cursorline = true
  if self:is_active() then
    return
  end

  self.win_leave = vim.api.nvim_create_autocmd("WinLeave", {
    callback = function()
      vim.opt_local.cursorline = false
    end,
  })
  self.win_enter = vim.api.nvim_create_autocmd("WinEnter", {
    callback = function()
      vim.opt_local.cursorline = true
    end,
  })
  self.buf_win_enter = vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function()
      vim.opt_local.cursorline = true
    end,
  })
end

function M:deactive()
  vim.opt.cursorline = false
  vim.opt_local.cursorline = false
  if not self:is_active() then
    return
  end
  pcall(vim.api.nvim_del_autocmd, self.win_leave)
  pcall(vim.api.nvim_del_autocmd, self.win_enter)
  pcall(vim.api.nvim_del_autocmd, self.buf_win_enter)
  self.win_leave = nil
  self.win_enter = nil
  self.buf_win_enter = nil
end

-- 'cursorline' local to window
function M:toggle()
  ---@diagnostic disable-next-line: undefined-field
  local cursorline = vim.opt_local.cursorline:get()
  reset_cursorline()
  if cursorline then
    self:deactive()
  else
    self:active()
  end
end

return M
