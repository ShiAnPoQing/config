local M = {}
local border = {
	-- 左上角
	"╭",
	-- 上边框
	"─",
	-- 右上角
	"╮",
	-- 右边框
	"│",
	-- 右下角
	"╯",
	-- 下边框
	"─",
	-- 左下角
	"╰",
	-- 左边框
	"│",
}

local function move_float_win(pos)
	local opts = vim.api.nvim_win_get_config(0)

	local row
	local col

	if pos == "j" then
		row = opts.row + 1
		col = opts.col
	elseif pos == "k" then
		row = opts.row - 1
		col = opts.col
	elseif pos == "h" then
		row = opts.row
		col = opts.col - 1
	elseif pos == "l" then
		row = opts.row
		col = opts.col + 1
	end
	vim.api.nvim_win_set_config(0, { row = row, col = col, relative = "editor" })
end

function M.extmark_doc()
	local width = vim.api.nvim_win_get_width(0)
	local height = vim.api.nvim_win_get_height(0)

	local win_height = math.ceil(height * 0.6)
	local win_width = math.ceil(width * 0.6)

	local row = math.ceil((height - win_height) / 2)
	local col = math.ceil((width - win_width) / 2)

	local opts = {
		relative = "editor",
		width = win_width,
		height = win_height,
		row = row,
		col = col,
		style = "minimal",
		border = border,
	}
	local buf = vim.api.nvim_create_buf(false, true)
	local win = vim.api.nvim_open_win(buf, true, opts)

	local file = io.open(vim.fn.stdpath("config") .. "/lua/nvim-extmark-doc/nvim_set_extmark.txt", "r")
	local lines = {}

	for line in file:lines() do
		table.insert(lines, line)
	end

	vim.api.nvim_buf_set_lines(buf, 0, 1, false, lines)
	vim.api.nvim_buf_set_option(buf, "filetype", "help")
	vim.api.nvim_buf_set_option(buf, "modifiable", false)
	vim.api.nvim_buf_set_option(buf, "number", true)
	vim.api.nvim_win_set_option(win, "winhighlight", "Visual:search")

	vim.keymap.set("n", "<C-j>", function()
		move_float_win("j")
	end, { buffer = buf })
	vim.keymap.set("n", "<C-k>", function()
		move_float_win("k")
	end, { buffer = buf })
	vim.keymap.set("n", "<C-h>", function()
		move_float_win("h")
	end, { buffer = buf })
	vim.keymap.set("n", "<C-l>", function()
		move_float_win("l")
	end, { buffer = buf })
end

return M
