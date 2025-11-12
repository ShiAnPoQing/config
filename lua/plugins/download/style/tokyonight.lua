return {
  "folke/tokyonight.nvim",
  priority = 1000,
  colorscheme = {
    "tokyonight",
    "tokyonight-night",
    "tokyonight-storm",
    "tokyonight-day",
    "tokyonight-moon",
  },
  config = function()
    require("tokyonight").setup()
  end,
}
