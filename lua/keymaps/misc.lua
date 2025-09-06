return {
  -- ["<C-\\>"] = { "gcc", { "n", "i" } },
  ["<C-[>"] = { "<C-O>", "n" },
  ["<M-->"] = { "J", "x" },
  ["<M-b>"] = {
    "<C-G>o<C-G>",
    "s",
  },
  ["a"] = {
    "<nop>",
    "n",
  },
  -- ["s"] = {
  --   "<nop>",
  --   "n"
  -- },
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
  -- enlarge base cursor move
  ["m+"] = {
    function()
      local M = require("move-size")
      local count = vim.v.count1
      M.ChangeMoveSize(count, "up")
    end,
    { "n" },
  },
  -- reduce base cursor move
  ["m-"] = {
    function()
      local M = require("move-size")
      local count = vim.v.count1
      M.ChangeMoveSize(count, "down")
    end,
    { "n" },
  },
  -- reset base cursor move
  ["m<BS>"] = {
    function()
      require("move-size").ChangeMoveSize_reset()
    end,
    { "n" },
  },
  -- del line start space
  ["<leader>db<space>"] = {
    {
      function()
        local D = require("del-space")
        local count = vim.vim.count1
        D.delSpace(count, "n")
      end,
      { "n" },
    },
    {
      function()
        local D = require("del-space")
        local count = vim.vim.count1
        D.delSpace(count, "v")
      end,
      { "v" },
    },
  },
  -- gh: normal mode into select mode
  -- normal mode into select block mode
  ["<space>gh"] = { "g<C-h>", { "n" } },
  -- visual mode and select mode exchange
  ["gh"] = {
    { "<C-g>", { "x" } },
    { "<C-g>", { "s" } },
  },
  -- select mode select line
  ["gH"] = { "<C-g>gH", { "s" } },
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
  -- block visual
  ["<space>gv"] = { "`[v`]", { "n" } },
  -- virtualedit = "all"
  ["<space>v"] = { "<C-v>", { "n", "x" } },
  -- virtualedit = "none"
  ["<space><space>v"] = {
    function()
      vim.opt.virtualedit = ""
      vim.api.nvim_exec2(
        [[
      execute "normal! $\<C-v>"
      ]],
        {}
      )
      vim.api.nvim_create_autocmd("ModeChanged", {
        group = vim.api.nvim_create_augroup("CustomModeChanged", { clear = true }),
        callback = function(ev)
          vim.opt.virtualedit = "all"
          vim.api.nvim_del_autocmd(ev.id)
        end,
      })
    end,
    "n",
  },
  ["<C-Space><C-K>"] = {
    "<C-K>",
    "i",
  },
}
