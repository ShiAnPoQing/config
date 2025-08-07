local M = {}

function M.change_layout()
  local winnr = vim.fn.winnr("j")
  local id = vim.fn.win_getid(winnr)
  local layout = vim.fn.winlayout()
  print(vim.inspect(layout))
end

return M
