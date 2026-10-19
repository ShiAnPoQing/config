--- @class my.env.pro.change
local M = my.util.defer_require(..., {})

function M.trim_current_line()
  local line = vim.api.nvim_get_current_line()
  local cur_col = vim.fn.col(".")
  local col = line:find("%S")
  vim.api.nvim_set_current_line(vim.trim(line))
  vim.api.nvim_win_set_cursor(0, { vim.api.nvim_win_get_cursor(0)[1], cur_col - col })
end

return M
