local M = {}

function M.showFileInfo()
	local info = vim.fn.expand("%:p")
	local MAXWIDTH = 50

	local lineCount = vim.api.nvim_buf_line_count(0)

	local opts = {
		relative = "editor",
		width = #info < MAXWIDTH and #info or MAXWIDTH,
		row = 0,
		col = 0,
		height = 5,
		anchor = "NW",
		style = "minimal",
		border = "rounded",
	}
	local buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(buf, 0, 1, false, { info, lineCount .. " lines" })
	vim.api.nvim_set_hl(0, "floatWin", { bg = "black" })

	local win = vim.api.nvim_open_win(buf, true, opts)
	vim.api.nvim_buf_set_option(buf, "modifiable", false)
	vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", "<cmd>lua require('float-win').test1()<cr>", {})
	vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>q!<cr>", {})
	vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>q!<cr>", {})
	vim.api.nvim_buf_set_keymap(buf, "n", "<C-j>", "<cmd>lua require('float-win').updataWinPos('j')<cr>", {})
	vim.api.nvim_buf_set_keymap(buf, "n", "<C-k>", "<cmd>lua require('float-win').updataWinPos('k')<cr>", {})
	vim.api.nvim_buf_set_keymap(buf, "n", "<C-h>", "<cmd>lua require('float-win').updataWinPos('h')<cr>", {})
	vim.api.nvim_buf_set_keymap(buf, "n", "<C-l>", "<cmd>lua require('float-win').updataWinPos('l')<cr>", {})
	vim.api.nvim_win_set_option(win, "winhl", "Normal:floatWin")

	-- 获取屏幕最大高度
	-- local height = vim.api.nvim_get_option("lines")
	-- local width = vim.api.nvim_get_option("columns")
	-- print(width)
end

return M
