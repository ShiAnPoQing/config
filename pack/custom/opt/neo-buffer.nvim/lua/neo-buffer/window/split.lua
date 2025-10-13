local Window = require("neo-buffer.window.window")

local M = {}

function M:create(buf, position)
  local before = vim.api.nvim_tabpage_list_wins(0)
  if position == "left" then
    vim.cmd("topleft vert split | buffer " .. buf)
  elseif position == "right" then
    vim.cmd("botright vert split | buffer " .. buf)
  elseif position == "top" then
    vim.cmd("topleft split | buffer " .. buf)
  elseif position == "bottom" then
    vim.cmd("botright split | buffer " .. buf)
  end
  local after = vim.api.nvim_tabpage_list_wins(0)
  local win
  for _, w in ipairs(after) do
    if not vim.tbl_contains(before, w) then
      win = w
    end
  end
  Window.set_win_option(win)
  self.win = win
end

function M:update() end

return M
