local M = {}

local autocmds = {}
local on

function M.toggle_cursorline()
  if not on then
    vim.opt.cursorline = true
    on = true
    local winleave = vim.api.nvim_create_autocmd("WinLeave", {
      callback = function()
        vim.opt.cursorline = false
      end,
    })
    local winenter = vim.api.nvim_create_autocmd("WinEnter", {
      callback = function()
        vim.opt.cursorline = true
      end,
    })
    autocmds = { winleave, winenter }
  else
    vim.opt.cursorline = false
    on = nil
    for _, v in ipairs(autocmds) do
      vim.api.nvim_del_autocmd(v)
    end
  end
end

return M
