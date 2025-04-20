return {
  -- quit insert mode quickly
  ["jk"] = {
    { "<Esc>",      { "i" } },
    { "<C-u><ESC>", { "c" } },
  },
  ["jj"] = {
    { "<Esc>",      { "i" } },
    { "<C-u><ESC>", { "c" } },
  },
  ["kj"] = {
    { "<Esc>l",     { "i" } },
    { "<C-u><ESC>", { "c" } },
  },
  ["kk"] = {
    { "<Esc>l",     { "i" } },
    { "<C-u><ESC>", { "c" } },
  },
  [";;"] = {
    { "<Esc>",      { "i" } },
    { "<C-u><ESC>", { "c" } },
  },
  ["；；"] = {
    { "<Esc>",      { "i" } },
    { "<C-u><ESC>", { "c" } },
  },
  ["<space>c"] = { ":close<CR>", "n" },
  ["<space><space>c"] = { ":close!<CR>", "n" },

  ["<space>q"] = { ":q<CR>", "n" },
  ["<space><space>q"] = { ":q!<CR>", "n" },
  ["<space><space><space>q"] = { ":qa!<CR>", "n" },
}
