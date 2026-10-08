--- @class my.env.promax.motion.INSERT
local M = {}

function M.first()
  vim.api.nvim_feedkeys(vim.keycode("<C-o>") .. "0", "n", false)
end

function M.last()
  vim.api.nvim_feedkeys(vim.keycode("<C-o>") .. "$" .. vim.keycode("<right>"), "n", false)
end

function M.first_non_blank()
  vim.api.nvim_feedkeys(vim.keycode("<C-o>") .. "^", "n", false)
end

function M.last_non_blank()
  vim.api.nvim_feedkeys(vim.keycode("<C-o>") .. "g_" .. vim.keycode("<right>"), "n", false)
end

return M
