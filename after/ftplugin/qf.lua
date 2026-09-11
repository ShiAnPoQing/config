local bufnr = vim.api.nvim_get_current_buf()
-- vim.keymap.set("n", "<cr>", "<cr>", { buf = bufnr })
vim.keymap.set("n", "q", "<cmd>close<cr>", { buf = bufnr })
vim.keymap.set("n", "<esc>", "<cmd>close<cr>", { buf = bufnr })
