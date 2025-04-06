local M = {}

function M.test()
  local opts = {
    relative = "editor",
    width = 10,
    row = 0,
    col = 0,
    height = 5,
    anchor = "NW",
    style = "minimal",
    border = "rounded",
  }
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, 1, false, { "你好" })
  vim.api.nvim_set_hl(0, "floatWin", { bg = "black" })

  local win = vim.api.nvim_open_win(buf, true, opts)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", "<cmd>lua require('float-win').test1()<cr>", {})
  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>q!<cr>", {})
  vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>q!<cr>", {})
  vim.api.nvim_buf_set_keymap(buf, "n", "<C-j>", "<cmd>lua require('float-win').updataWinPos('j')<cr>", {})
  vim.api.nvim_buf_set_keymap(buf, "n", "<C-k>", "<cmd>lua require('float-win').updataWinPos('k')<cr>", {})
  vim.api.nvim_buf_set_keymap(buf, "n", "<C-h>", "<cmd>lua require('float-win').updataWinPos('h')<cr>", {})
  vim.api.nvim_buf_set_keymap(buf, "n", "<C-l>", "<cmd>lua require('float-win').updataWinPos('l')<cr>", {})
  vim.api.nvim_win_set_option(win, "winhl", "Normal:floatWin")
end

function M.updataWinPos(pos)
  local opts = vim.api.nvim_win_get_config(0)

  local row
  local col

  if pos == "j" then
    row = opts.row[false] + 1
    col = opts.col[false]
  elseif pos == "k" then
    row = opts.row[false] - 1
    col = opts.col[false]
  elseif pos == "h" then
    row = opts.row[false]
    col = opts.col[false] - 1
    print(col)
  elseif pos == "l" then
    row = opts.row[false]
    col = opts.col[false] + 1
    print(col)
  end
  vim.api.nvim_win_set_config(0, { row = row, col = col, relative = "editor" })
end

function M.test1()
  local pos = vim.api.nvim_win_get_cursor(0)
  local line = vim.api.nvim_buf_get_lines(0, pos[1] - 1, pos[1], false)
end

return M
