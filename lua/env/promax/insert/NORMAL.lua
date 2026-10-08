--- @class my.env.promax.insert.NORMAL
local M = {}

function M.cursor()
  vim.api.nvim_feedkeys("i", "n", false)
end

function M.first()
  vim.api.nvim_feedkeys("0i", "n", false)
end

function M.last()
  vim.api.nvim_feedkeys("A", "n", false)
end

function M.first_non_blank()
  vim.api.nvim_feedkeys("^i", "n", false)
end

function M.last_non_blank()
  vim.api.nvim_feedkeys(vim.keycode("<cmd>lua my.motion.NORMAL.last_non_blank()<cr>"), "n", false)
  vim.api.nvim_feedkeys("i", "n", false)
end

function M.open_line_below()
  vim.api.nvim_feedkeys("o", "n", false)
end

function M.open_line_above()
  vim.api.nvim_feedkeys("O", "n", false)
end

return M
