local M = {}

function M.get_window_size(win_id)
	-- 获取当前窗口
	win_id = win_id or vim.api.nvim_get_current_win()

	-- 获取窗口大小
	local width = vim.api.nvim_win_get_width(win_id)
	local height = vim.api.nvim_win_get_height(win_id)

	return {
		width = width,
		height = height,
	}
end

return M
