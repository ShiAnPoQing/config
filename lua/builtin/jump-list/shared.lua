local M = {}

M.JUMP_NEW_KEY = vim.api.nvim_replace_termcodes("<C-i>", true, false, true)
M.JUMP_OLD_KEY = vim.api.nvim_replace_termcodes("<C-o>", true, false, true)

return M
