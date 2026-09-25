local M = {
  RELOAD = "<Plug>(nvim-dir-reload)",
  VSPLIT = "<Plug>(nvim-dir-vsplit)",
  OPEN = "<Plug>(nvim-dir-open)",
  SPLIT = "<Plug>(nvim-dir-split)",
  UP = "<Plug>(nvim-dir-up)",
}
M.reload = function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(M.RELOAD, true, false, true), "n", false)
end
M.vsplit = function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(M.VSPLIT, true, false, true), "n", false)
end
M.open = function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(M.OPEN, true, false, true), "n", false)
end
M.split = function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(M.SPLIT, true, false, true), "n", false)
end
M.up = function()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(M.UP, true, false, true), "n", false)
end

return M
