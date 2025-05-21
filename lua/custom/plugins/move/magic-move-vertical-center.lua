local M = {}

function M.move_vertical_center()
  local count = vim.v.count1

  if count == 1 then
    vim.api.nvim_feedkeys("M", "nx", false)
  else
    local cursor_row = unpack(vim.api.nvim_win_get_cursor(0))
  end
end

return M
