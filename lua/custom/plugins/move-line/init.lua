local utils = require("utils.mark")

local M = {}

--- @param dir "up"|"down"
function M.move_line(dir)
	local mode = vim.api.nvim_get_mode().mode
	local count = vim.v.count1

	if mode == "n" or mode == "i" then
		local line_count = vim.api.nvim_buf_line_count(0)
		local row, col = unpack(vim.api.nvim_win_get_cursor(0))
		local lines = vim.api.nvim_buf_get_lines(0, row - 1, row, false)

		if dir == "up" then
			count = -math.min(row - 1, count)
			vim.api.nvim_buf_set_lines(0, row - 1, row, false, {})
			vim.api.nvim_buf_set_lines(0, row + count - 1, row + count - 1, false, lines)
		else
			count = math.min(line_count - row, count)
			vim.api.nvim_buf_set_lines(0, row + count, row + count, false, lines)
			vim.api.nvim_buf_set_lines(0, row - 1, row, false, {})
		end

		vim.api.nvim_win_set_cursor(0, { row + count, col })
	elseif mode == "V" or mode == "" or mode == "v" then
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "nx", false)
		local line_count = vim.api.nvim_buf_line_count(0)
		local row, col = unpack(vim.api.nvim_win_get_cursor(0))
		local start_row, start_col, end_row, end_col = utils.get_visual_mark(true)
		local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)

		if dir == "up" then
			count = -math.min(start_row - 1, count)
			vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, {})
			vim.api.nvim_buf_set_lines(0, start_row + count - 1, start_row + count - 1, false, lines)
		else
			count = math.min(line_count - end_row, count)
			vim.api.nvim_buf_set_lines(0, end_row + count, end_row + count, false, lines)
			vim.api.nvim_buf_set_lines(0, start_row - 1, end_row, false, {})
		end

		if row == start_row then
			utils.set_visual_mark(end_row + count, end_col, start_row + count, start_col)
			vim.api.nvim_feedkeys("gv", "nx", false)
			vim.api.nvim_win_set_cursor(0, { row + count, col })
		else
			utils.set_visual_mark(start_row + count, start_col, end_row + count, end_col)
			vim.api.nvim_feedkeys("gv", "nx", false)
			vim.api.nvim_win_set_cursor(0, { row + count, col })
		end
	end
end

function M.setup() end

return M
