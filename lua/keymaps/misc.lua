return {
  ["<esc>"] = {
    function()
      ---@diagnostic disable-next-line: undefined-field
      vim.opt.hlsearch = not vim.opt.hlsearch:get()
    end,
    "n",
    desc = "Toggle highlight search",
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
  ["<space>f"] = { "t", { "n", "o", "x" } },
  ["<space>F"] = { "T", { "n", "o", "x" } },
  ["<M-b>"] = { "<C-G>o<C-G>", "s", desc = "Go to Other end of highlighted text" },
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
    { "s", "n" },
    { "d", "v" },
  },
  ["<space>r"] = { "gR", "n" },
  ["<C-f>"] = { ";", { "n" }, desc = "Repeat latest f, t, F or T [count] times" },
  ["<C-S-f>"] = { ",", { "n" }, desc = "Repeat latest f, t, F or T in opposite direction [count] times" },
  ["d"] = {
    function()
      local reg1 = vim.fn.getreg('"')
      local reg2 = vim.fn.getreg("+")
      local reg3 = vim.fn.getreg("1")
      if vim.api.nvim_get_current_line():match("^%s*$") then
        vim.schedule(function()
          vim.fn.setreg('"', reg1)
          vim.fn.setreg("+", reg2)
          vim.fn.setreg("1", reg3)
        end)
      end
      return "_"
    end,
    "o",
    expr = true,
  },
}
