return {
  "folke/flash.nvim",
  lazy = false,
  enable = true,
  event = "VeryLazy",
  opts = {},
  -- stylua: ignore
  keys = {
    { "0s",     mode = { "n", "x", "o" }, function() require("flash").jump() end,              desc = "Flash" },
    { "0S",     mode = { "n", "x", "o" }, function() require("flash").treesitter() end,        desc = "Flash Treesitter" },
    { "0r",     mode = "o",               function() require("flash").remote() end,            desc = "Remote Flash" },
    { "0R",     mode = { "o", "x" },      function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
    { "<c-s>", mode = { "c" },           function() require("flash").toggle() end,            desc = "Toggle Flash Search" },
  },
}
