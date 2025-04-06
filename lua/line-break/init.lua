local R = require("repeat")
local M = {}

function M.LineBreak(count, mode, textobj)
	R.Record(function()
		M.LineBreak(count, mode, textobj)
	end)
	M.linebreak = {}
	M.linebreak.mode = mode
	if mode ~= "v" then
		M.linebreak.begin_pos = vim.api.nvim_win_get_cursor(0)
	end

	if M.linebreak_operate_begin == nil then
		_G.my_linebreak = function(type)
			local begin_line_number
			local end_line_number

			if M.linebreak.mode == "v" then
				vim.cmd([[
        exe "norm! " .. "\<ESc>"
        ]])
			end

			if type == "line" then
				begin_line_number = vim.api.nvim_buf_get_mark(0, "[")
				end_line_number = vim.api.nvim_buf_get_mark(0, "]")
			elseif type == "char" then
				begin_line_number = vim.api.nvim_buf_get_mark(0, "[")
				end_line_number = vim.api.nvim_buf_get_mark(0, "]")
			elseif type == "block" then
				begin_line_number = vim.api.nvim_buf_get_mark(0, "[")
				end_line_number = vim.api.nvim_buf_get_mark(0, "]")
			end

			local begin_pos

			if M.linebreak.mode ~= "v" then
				begin_pos = { begin_line_number[1], M.linebreak.begin_pos[2] }
			else
				begin_pos = begin_line_number
			end

			if begin_pos[2] == 0 then
				return
			end

			local loop_end = 0

			vim.api.nvim_win_set_cursor(0, begin_pos)

			local i = 0
			local max = 0

			while true do
				max = max + 1

				if max > 300 then
					break
				end

				local begin_pos = vim.api.nvim_win_get_cursor(0)
				local current_line = vim.api.nvim_get_current_line()
				local line_len = string.len(current_line)

				if begin_pos[1] == end_line_number[1] + i then
					loop_end = 1
				end

				if line_len > begin_pos[2] then
					-- 特殊键必须使用双引号
					vim.cmd([[
          exec 'norm! i' .. "\<CR>"
          ]])

					vim.api.nvim_win_set_cursor(0, begin_pos)

					vim.cmd("norm! j")

					i = i + 1
				else
					vim.cmd("norm! j")
					if loop_end == 1 then
						break
					end
				end
			end
		end

		vim.opt.operatorfunc = "v:lua.my_linebreak"
		vim.api.nvim_feedkeys("g@", "n", false)
		M.linebreak_operate_begin = 0
	else
		vim.api.nvim_feedkeys("g@", "n", false)
	end
end

return M
