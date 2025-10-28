vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({
      higroup = "CurSearch",
    })
  end,
})

vim.api.nvim_create_autocmd("VimResized", {
  pattern = "*",
  callback = function()
    vim.cmd("wincmd =")
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    vim.api.nvim_exec2([[silent! normal! g`"zv]], { output = false })
  end,
})

-- vim.api.nvim_create_autocmd("InsertEnter", {
--   callback = function()
--     vim.opt.list = true
--   end,
-- })
--
-- vim.api.nvim_create_autocmd("InsertLeave", {
--   callback = function()
--     vim.opt.list = false
--   end,
-- })
