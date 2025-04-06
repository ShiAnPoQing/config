local M = {}

function M.switch(option)
  vim.opt[option] = not vim.opt[option]:get()
end

return M
