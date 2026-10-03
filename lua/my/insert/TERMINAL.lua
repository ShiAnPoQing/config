--- @class my.insert.TERMINAL
local M = {}

function M.last()
  vim.api.nvim_feedkeys(vim.keycode("i<end>"), "n", false)
end

function M.last_non_blank()
  vim.api.nvim_feedkeys(vim.keycode("i<end>"), "n", false)
end

function M.first()
  vim.api.nvim_feedkeys(vim.keycode("i<home>"), "n", false)
end

function M.first_non_blank()
  vim.api.nvim_feedkeys(vim.keycode("i<home>"), "n", false)
end

return M
