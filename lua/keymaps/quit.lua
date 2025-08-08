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
  ["<space>c"] = { "<cmd>close<cr>", "n" },
  ["<space><space>c"] = { "<cmd>close!<cr>", "n" },

  ["<space>q"] = { "<cmd>q<cr>", "n" },
  ["<space><space>q"] = { "<cmd>q!<cr>", "n" },
  ["<space><space><space>q"] = { "<cmd>qa!<cr>", "n" },
}
