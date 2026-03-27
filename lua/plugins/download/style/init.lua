return {
  {
    "rose-pine/neovim",
    -- lazy = false,
    colorscheme = {
      "rose-pine",
      "rose-pine-moon",
      "rose-pine-main",
      "rose-pine-dawn",
    },
    config = function()
      vim.cmd("colorscheme rose-pine-dawn")
      -- vim.cmd("colorscheme rose-pine-main")
      -- vim.cmd("colorscheme rose-pine-moon")
      -- vim.cmd("colorscheme rose-pine-dawn")
    end,
  },
  {
    "bluz71/vim-moonfly-colors",
    lazy = false,
    priority = 1000,
    colorscheme = "moonfly",
    config = function()
      vim.g.moonflyTransparent = true
      vim.g.moonflyVirtualTextColor = true
      require("moonfly").custom_colors({
        -- bg = "#000000",
        -- violet = "#ff74b8",
      })
      vim.cmd([[colorscheme moonfly]])
    end,
  },
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    lazy = true,
    colorscheme = {
      "tokyonight",
      "tokyonight-day",
      "tokyonight-storm",
      "tokyonight-night",
      "tokyonight-moon",
    },
    config = function()
      require("tokyonight").setup({
        -- transparent = true,
      })
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
  {
    "BrokenSunny/paradox.nvim",
    priority = 1000,
    -- lazy = false,
    colorscheme = "paradox",
    config = function()
      require("paradox").setup()
      -- local time = tonumber(os.date("%H"))
      -- if time >= 17 or time < 7 then
      --   vim.o.background = "dark"
      -- else
      --   vim.o.background = "light"
      -- end
      vim.o.background = "light"
      vim.cmd([[colorscheme paradox]])
    end,
  },
  {
    "rebelot/kanagawa.nvim",
    colorscheme = { "kanagawa-wave", "kanagawa-dragon", "kanagawa-lotus" },
    config = function()
      require("kanagawa").setup()
      vim.cmd([[colorscheme kanagawa-wave]])
    end,
  },
  {
    "AlexvZyl/nordic.nvim",
    priority = 1000,
    colorscheme = "nordic",
    config = function()
      ---@diagnostic disable-next-line: missing-parameter
      require("nordic").load()
    end,
  },
  {
    "theniceboy/nvim-deus",
    colorscheme = "deus",
  },
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    colorscheme = "gruvbox",
    config = function()
      require("gruvbox").setup({})
      vim.cmd("colorscheme gruvbox")
    end,
  },
  {
    "sainnhe/everforest",
    -- priority = 1000,
    colorscheme = "everforest",
    config = function()
      vim.g.everforest_enable_italic = true
      vim.opt.background = "dark"
      vim.cmd.colorscheme("everforest")
    end,
  },
  {
    "Iron-E/nvim-highlite",
    lazy = true,
    colorscheme = {
      "highlite",
      "highlite-ayu",
      "highlite-everforest",
      "highlite-gruvbox",
      "highlite-gruvbox-material",
      "highlite-iceberg",
      "highlite-molokai",
      "highlite-papercolor",
    },
    config = function()
      require("highlite").setup({ generator = { plugins = { vim = false }, syntax = false } })
      vim.cmd("colorscheme highlite-iceberg")
    end,
    -- version = "^4.0.0",
  },
  {
    "olimorris/onedarkpro.nvim",
    priority = 1000, -- Ensure it loads first
    colorscheme = {
      "onedark",
      "onelight",
      "onedark_vivid",
      "onedark_dark",
      "vaporwave",
    },
  },
  {
    "vague-theme/vague.nvim",
    priority = 1000, -- make sure to load this before all the other plugins
    colorscheme = "vague",
    config = function()
      require("vague").setup({
        -- optional configuration here
      })
      vim.cmd("colorscheme vague")
    end,
  },
  {
    "rmehri01/onenord.nvim",
    priority = 1000,
    lazy = true,
    colorscheme = "onenord",
    config = function()
      require("onenord").setup()
      vim.cmd("colorscheme onenord")
    end,
  },
}
