local M = {}

--- @param LR "left"|"right"
function M.start_end_move(LR)
  local count = vim.v.count1

  if LR == "left" then
    if count == 1 then
      local cursor1 = vim.api.nvim_win_get_cursor(0)
      vim.api.nvim_feedkeys("^", "nx", false)
      local cursor2 = vim.api.nvim_win_get_cursor(0)
      if cursor1[2] == cursor2[2] then
        vim.api.nvim_feedkeys("0", "nx", false)
      end
    else
      vim.api.nvim_feedkeys(count - 1 .. "-", "n", false)
    end
  else
    local cursor1 = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_feedkeys(count .. "g_", "nx", false)
    local cursor2 = vim.api.nvim_win_get_cursor(0)
    if cursor1[2] == cursor2[2] then
      vim.api.nvim_feedkeys("$", "nx", false)
    end
  end
end

return M
