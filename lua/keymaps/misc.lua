return {
  ["X"] = {
    '"_X',
    "n",
  },
  ["s"] = {
    '"_s',
    "n",
  },
  ["x"] = {
    '"_x',
    "n",
  },
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
  -- t 的优先级低，单独占用一个键，不合适
  ["t"] = { "<nop>", { "n", "o", "x" } },
  ["<space>f"] = { "t", { "n", "o", "x" } },
  ["<space>F"] = { "T", { "n", "o", "x" } },
  -- ["<C-\\>"] = { "gcc", { "n", "i" } },
  -- ["<C-[>"] = { "<C-O>", "n" },
  ["<M-->"] = { "J", "x" },
  ["<M-b>"] = {
    "<C-G>o<C-G>",
    "s",
  },
  ["a"] = {
    "<nop>",
    "n",
  },
  ["<S-bs>"] = {
    "x",
    "n",
  },
  ["<space><bs>"] = {
    "s",
    "n",
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

  -- show press key
  ["<leader>sk"] = {
    function()
      local K = require("key-show")
      K.keyShow()
    end,
    "n",
  },
  -- hidden press key show
  ["<leader>hk"] = {
    function()
      require("key-show").keyHide()
    end,
    "n",
  },
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
    { "X", "n" },
    { "d", "v" },
  },
  ["<space>r"] = { "gR", "n" },
  -- repeat latest f
  ["<M-f>"] = { ";", { "n" } },
  -- repeat latest F
  ["<M-S-f>"] = { ",", { "n" } },
  -- 输入二合字母
  ["<C-Space><C-K>"] = { "<C-K>", "i" },
}
