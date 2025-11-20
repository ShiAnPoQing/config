return {
  "rebelot/kanagawa.nvim",
  lazy = true,
  -- colorscheme = { "kanagawa-wave", "kanagawa-dragon", "kanagawa-lotus" },
  config = function()
    require("kanagawa").setup()
  end,
}
