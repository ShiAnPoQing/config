return {
  -- copy file name
  ["<leader>cf"] = {
    '<cmd>let @+ = expand("%")<CR>',
    { "n" },
  },
  -- copy file path
  ["<leader>cp"] = {
    '<cmd>let @+ = expand("%:p")<CR>',
    { "n" },
  },
}
