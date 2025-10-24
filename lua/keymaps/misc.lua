return {
  -- ["X"] = {
  --   '"_X',
  --   "n",
  -- },
  -- ["s"] = {
  --   '"_s',
  --   "n",
  -- },
  -- ["x"] = {
  --   '"_x',
  --   "n",
  -- },
  ["<leader>X"] = {
    "<cmd>source %<cr>",
    "n",
    { desc = "Source ths lua file" },
  },
  ["<leader>x"] = {
    {
      ":.lua<cr>",
      "n",
      { desc = "Run cursor line" },
    },
    {
      ":lua<cr>",
      "x",
      { desc = "Run selected" },
    },
  },
  ["<space>f"] = { "t", { "n", "o", "x" } },
  ["<space>F"] = { "T", { "n", "o", "x" } },
  -- ["<C-\\>"] = { "gcc", { "n", "i" } },
  -- ["<C-[>"] = { "<C-O>", "n" },
  ["<M-->"] = { "J", "x" },
  ["<M-b>"] = {
    "<C-G>o<C-G>",
    "s",
    desc = "Go to Other end of highlighted text",
  },
  -- ["<M-bs>"] = {
  --   "s",
  --   "n"
  -- },
  -- ["<C-bs>"] = {
  --   "S",
  --   "n"
  -- },
  -- ["<space>C"] = {
  --   "v0c",
  --   "n"
  -- },
  -- open myvimrc
  ["<leader><F5>"] = {
    function()
      local path = vim.fn.expand("$MYVIMRC"):gsub("init.lua", "")
      vim.fn.chdir(path)
      vim.cmd("e $MYVIMRC")
    end,
    "n",
    { desc = "Edit my neovim config" },
  },
  -- gh: normal mode into select mode
  -- normal mode into select block mode
  ["<space>gh"] = { "g<C-h>", "n" },
  -- visual mode and select mode exchange
  ["gh"] = {
    { "<C-g>", "x" },
    { "<C-g>", "s" },
  },
  -- select mode select line
  ["gH"] = {
    { "<C-g>", "s" },
    { "<C-g>", "x" },
  },
  -- select mode delete select text
  ["<BS>"] = {
    { "<C-g>s", "s" },
    -- { "X", "n" },
    { "s", "n" },
    { "d", "v" },
  },
  ["<space>r"] = { "gR", "n" },
  -- repeat latest f
  ["<M-f>"] = { ";", { "n" } },
  -- repeat latest F
  ["<M-S-f>"] = { ",", { "n" } },
  ["<C-Space><C-K>"] = { "<C-K>", "i" },
}
