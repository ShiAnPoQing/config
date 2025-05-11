return {
  ["<C-[>"] = { "<C-O>", "n" },
  ["<M-->"] = { "J", "x" },
  ["<C-.>"] = { "<C-T>", "i" },
  ["<C-space><C-,>"] = { "0<C-D>", "i" },
  ["<C-,>"] = { "<C-D>", "i" },
  ["<C-space><C-.>"] = { "^<C-D>", "i" },
  ["<M-b>"] = {
    "<C-G>o<C-G>",
    "s"
  },
  ["a"] = {
    "<nop>",
    "n"
  },
  ["s"] = {
    "<nop>",
    "n"
  },
  ["<bs>"] = {
    "X",
    "n"
  },
  ["<S-bs>"] = {
    "x",
    "n"
  },
  ["<space><bs>"] = {
    "s",
    "n"
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
  [";sk"] = {
    function()
      local K = require("key-show")
      K.keyShow()
      require("repeat").Record(function()
        K.keyShow()
      end)
    end,
    "n",
  },
  -- hidden press key show
  [";hk"] = {
    function()
      require("key-show").keyHide()
    end,
    "n",
  },
  -- open myvimrc
  [";<F5>"] = { ":e $MYVIMRC<cr>", "n", { desc = "Edit my neovim config" } },
  -- enlarge base cursor move
  ["m+"] = {
    function()
      local M = require("move-size")
      local count = vim.v.count1
      M.ChangeMoveSize(count, "up")
      require("repeat").Record(function()
        M.ChangeMoveSize(count, "up")
      end)
    end,
    { "n" },
  },
  -- reduce base cursor move
  ["m-"] = {
    function()
      local M = require("move-size")
      local count = vim.v.count1
      M.ChangeMoveSize(count, "down")
      require("repeat").Record(function()
        M.ChangeMoveSize(count, "down")
      end)
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
  [";db<space>"] = {
    {
      function()
        local D = require("del-space")
        local count = vim.vim.count1
        D.delSpace(count, "n")
        require("repeat").Record(function()
          D.delSpace(count, "n")
        end)
      end,
      { "n" },
    },
    {
      function()
        local D = require("del-space")
        local count = vim.vim.count1
        D.delSpace(count, "v")
        require("repeat").Record(function()
          D.delSpace(count, "v")
        end)
      end,
      { "v" },
    },
  },

  -- Keep window centered when going up/down
  ["n"] = {
    "nzzzv",
    "n",
  },
  ["N"] = {
    "Nzzzv",
    "n",
  },

  ["<space>u"] = { "U", "n" },
  ["U"] = { "<C-R>", "n" },
  ["<space><space>-"] = {
    function()
      require("switch-function").switch("wrap")
    end,
    { "n" },
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
  ["<BS>"] = { "<C-g>s", "s" },
  ["<space>r"] = { "gR", "n" },
  -- repeat latest f
  ["<M-f>"] = { ";", { "n" } },
  -- repeat latest F
  ["<M-S-f>"] = { ",", { "n" } },
  -- block visual
  -- virtualedit = "all"
  ["<space>v"] = { "<C-v>", { "n", "x" } },
  -- virtualedit = "none"
  ["<space><space>v"] = {
    function()
      vim.opt.virtualedit = "none"
      vim.api.nvim_exec2([[
      execute "normal! $\<C-v>"
      ]], {})

      local group = vim.api.nvim_create_augroup('CustomModeChanged', { clear = true })
      vim.api.nvim_create_autocmd('ModeChanged', {
        group = group,
        callback = function(ev)
          vim.opt.virtualedit = "all"
          vim.api.nvim_del_autocmd(ev.id)
        end
      })
    end,
    "n"
  }
}
