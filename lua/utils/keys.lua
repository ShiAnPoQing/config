local M = {
  CTRL_BS = "<C-BS>",
}

if vim.env.TERM == "xterm-ghostty" or vim.env.TERM == "tmux-256color" then
  M.CTRL_BS = "<F17>"
end

return M
