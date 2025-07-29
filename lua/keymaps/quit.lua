return {
  -- quit insert mode quickly
  ["jk"] = {
    { "<Esc>", { "i" } },
    { "<C-u><ESC>", { "c" } },
    -- { "<C-\\><C-N>", "t" }
  },
  ["jj"] = {
    { "<Esc>", { "i" } },
    { "<C-u><ESC>", { "c" } },
    -- { "<C-\\><C-N>", "t" }
  },
  ["kj"] = {
    { "<Esc>l", { "i" } },
    { "<C-u><ESC>", { "c" } },
    -- { "<C-\\><C-N>", "t" }
  },
  ["kk"] = {
    { "<Esc>l", { "i" } },
    { "<C-u><ESC>", { "c" } },
    -- { "<C-\\><C-N>", "t" }
  },
  [";;"] = {
    { "<Esc>", { "i" } },
    { "<C-u><ESC>", { "c" } },
    { "<C-\\><C-N>", "t" },
  },
  ["；；"] = {
    { "<Esc>", { "i" } },
    { "<C-u><ESC>", { "c" } },
  },
  ["<space>c"] = { ":close<CR>", "n" },
  ["<space><space>c"] = { ":close!<CR>", "n" },

  ["<space>q"] = { ":q<CR>", "n" },
  ["<space><space>q"] = { ":q!<CR>", "n" },
  ["<space><space><space>q"] = { ":qa!<CR>", "n" },
}
