local R = require("repeat")
local M = {}

function M.copyLine(type)
	R.Record(function()
		M.copyLine(type)
	end)

	if type == "up" then
		local cursor_pos = vim.api.nvim_win_get_cursor(0)
		local current_line = vim.api.nvim_get_current_line()
		local up_line = vim.api.nvim_buf_get_text(0, cursor_pos[1] - 2, cursor_pos[2], cursor_pos[1] - 1, -1, {})[1]
		print(current_line, up_line)
	end
end

return M
