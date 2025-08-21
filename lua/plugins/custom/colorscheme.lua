return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/colorscheme",
  priority = 1000,
  lazy = false,
  name = "colorscheme",
  config = function(opt)
    require("colorscheme").setup()
    vim.o.background = "dark" -- or "light" for light mode
    vim.cmd([[colorscheme colorscheme]])
  end,
}
