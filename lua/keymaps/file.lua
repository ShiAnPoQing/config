return {
  -- copy file name
  ["<leader>yfn"] = {
    '<cmd>let @+ = expand("%")<CR>',
    { "n" },
  },
  -- copy file path
  ["<leader>yfp"] = {
    '<cmd>let @+ = expand("%:p")<CR>',
    { "n" },
  },
  ["<leader>cd"] = {
    "<cmd>ChangeDirectoryToFile<CR>",
    "n",
  },
}
