return {
  -- copy file name
  ["<leader>yfn"] = {
    '<cmd>let @+ = expand("%")<CR>',
    "n",
    desc = "Copy file name",
  },
  -- copy file path
  ["<leader>yfp"] = {
    '<cmd>let @+ = expand("%:p")<CR>',
    "n",
    desc = "Copy file path",
  },
  ["<leader>cd"] = {
    "<cmd>ChangeDirectoryToFile<CR>",
    "n",
    desc = "Change directory to file",
  },
}
