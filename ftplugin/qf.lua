local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set("n", "<cr>", "<cr>", { buf = bufnr })
