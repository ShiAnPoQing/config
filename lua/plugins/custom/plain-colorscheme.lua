return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/plain-colorscheme.nvim",
  priority = 1000,
  lazy = false,
  name = "plain-colorscheme",
  config = function(opt)
    require("plain-colorscheme").setup()
    vim.o.background = "dark" -- or "light" for light mode
    -- vim.o.background = "light" -- or "light" for light mode
    vim.cmd([[colorscheme plain-colorscheme]])
  end,
}
