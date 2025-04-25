local M = {}

--- @param action "left" | "right"
function M.select_start_end_move(action)
  local mode = vim.api.nvim_get_mode()

  if mode.mode == "" then
  end
  -- 

  vim.api.nvim_exec2([[
  execute "normal! \<C-G>d"
  ]], {})

  if action == "left" then
    vim.api.nvim_exec2([[
    execute "normal! ^P"
    ]], {})
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local text = vim.fn.getreg('"')

    vim.api.nvim_buf_set_mark(0, "<", row, col - #text + 1, {})
    vim.api.nvim_buf_set_mark(0, ">", row, col, {})
    vim.api.nvim_exec2([[
    execute "normal! gv\<C-G>"
    ]], {})
  else
    vim.api.nvim_exec2([[
    execute "normal! g_"
    ]], {})

    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local text = vim.fn.getreg('"')
    print(text)

    vim.api.nvim_buf_set_mark(0, "<", row, col + 1, {})
    vim.api.nvim_buf_set_mark(0, ">", row, col + #text, {})
    vim.api.nvim_exec2([[
    execute "normal! pgv\<C-G>"
    ]], {})
  end
end

return M
