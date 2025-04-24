local M = {}

function M.showFileInfo()
  local info = vim.fn.expand("%:p")
  local MAXWIDTH = 50
  local width = #info < MAXWIDTH and #info or MAXWIDTH
  local parent_width = vim.api.nvim_win_get_width(0)
  local parent_height = vim.api.nvim_win_get_height(0)

  local row = math.ceil((parent_height - 2) / 2)
  local col = math.ceil((parent_width - width) / 2)


  local opts = {
    relative = "editor",
    width = width,
    row = row,
    col = col,
    height = 2,
    anchor = "NW",
    style = "minimal",
    border = "rounded",
  }
  local buf = vim.api.nvim_create_buf(false, true)

  local line_count = vim.api.nvim_buf_line_count(0)
  vim.api.nvim_buf_set_lines(buf, 0, 1, false, { info, line_count .. " lines" })

  local win = vim.api.nvim_open_win(buf, true, opts)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  -- vim.api.nvim_buf_set_keymap(buf, "n", "<CR>", "<cmd>lua require('float-win').test1()<cr>", {})
  vim.api.nvim_buf_set_keymap(buf, "n", "<Esc>", "<cmd>q!<cr>", {})
  vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>q!<cr>", {})
  vim.api.nvim_buf_set_keymap(buf, "n", "<C-M-j>", "<cmd>lua require('utils.float.win-move').float_win_move('j')<cr>", {})
  vim.api.nvim_buf_set_keymap(buf, "n", "<C-M-k>", "<cmd>lua require('utils.float.win-move').float_win_move('k')<cr>", {})
  vim.api.nvim_buf_set_keymap(buf, "n", "<C-M-h>", "<cmd>lua require('utils.float.win-move').float_win_move('h')<cr>", {})
  vim.api.nvim_buf_set_keymap(buf, "n", "<C-M-l>", "<cmd>lua require('utils.float.win-move').float_win_move('l')<cr>", {})
  -- vim.api.nvim_win_set_option(win, "winhl", "Normal:floatWin")
end

return M
