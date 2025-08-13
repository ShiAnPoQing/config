local M = {}

function M.get_window_size(win_id)
  win_id = win_id or 0

  local width = vim.api.nvim_win_get_width(win_id)
  local height = vim.api.nvim_win_get_height(win_id)

  return {
    width = width,
    height = height,
  }
end

return M
