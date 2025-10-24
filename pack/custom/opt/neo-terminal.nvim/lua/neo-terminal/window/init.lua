local M = {}

function M:create() end

function M:close()
  pcall(vim.api.nvim_win_close, self.win, true)
  self.win = nil
end

function M:is_valid()
  return self.win and vim.api.nvim_win_is_valid(self.win)
end

return M
