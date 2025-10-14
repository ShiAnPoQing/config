--1. Yank buffer's relative path to clipboard
--2. Yank absolute path

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
  ["<leader>tcd"] = {
    "<cmd>ChangeTabDirectoryToFile<CR>",
    "n",
    desc = "Change directory to file",
  },
}
