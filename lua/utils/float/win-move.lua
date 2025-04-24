local M = {}

function M.float_win_move(pos)
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

return M
