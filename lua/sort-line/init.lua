local M = {}

-- @param mode: "v" | "n"
-- @return void
function M.sortLineByLength(mode)
	if vim.opt.operatorfunc ~= "v:lua.my_sort_line_by_length" then
		_G.my_sort_line_by_length = function(type)
			local begin_mark
			local end_mark

			if mode == "v" then
				vim.cmd([[
        exe "norm! " .. "\<ESC>"
        ]])
			end

			if type == "line" then
				begin_mark = vim.api.nvim_buf_get_mark(0, "[")
				end_mark = vim.api.nvim_buf_get_mark(0, "]")
			elseif type == "char" then
				begin_mark = vim.api.nvim_buf_get_mark(0, "[")
				end_mark = vim.api.nvim_buf_get_mark(0, "]")
			elseif type == "block" then
				begin_mark = vim.api.nvim_buf_get_mark(0, "[")
				end_mark = vim.api.nvim_buf_get_mark(0, "]")
			end

			local lines = vim.api.nvim_buf_get_lines(0, begin_mark[1] - 1, end_mark[1], false)
			table.sort(lines, function(a, b)
				return #a < #b
			end)
			vim.api.nvim_buf_set_lines(0, begin_mark[1] - 1, end_mark[1], false, lines)
		end

		vim.opt.operatorfunc = "v:lua.my_sort_line_by_length"
		vim.api.nvim_feedkeys("g@", "n", false)
	else
		vim.api.nvim_feedkeys("g@", "n", false)
	end
end

return M
