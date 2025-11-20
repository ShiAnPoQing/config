return {
  "folke/tokyonight.nvim",
  priority = 1000,
  -- lazy = true,
  -- colorscheme = {
  --   "tokyonight",
  --   "tokyonight-night",
  --   "tokyonight-storm",
  --   "tokyonight-day",
  --   "tokyonight-moon",
  -- },
  config = function()
    require("tokyonight").setup()
    vim.cmd.colorscheme("tokyonight-day")
  end,
}
