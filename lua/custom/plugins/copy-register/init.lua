local M = {}

function M.copy_register(operator)
  local char = vim.fn.nr2char(vim.fn.getchar())
  vim.api.nvim_feedkeys('"' .. char .. operator, "n", false)
end

return M
