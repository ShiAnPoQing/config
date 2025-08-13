return {
  "bluz71/vim-moonfly-colors",
  name = "moonfly",
  lazy = false,
  priority = 1000,
  config = function()
    vim.g.moonflyTransparent = true
    vim.g.moonflyVirtualTextColor = true
    require("moonfly").custom_colors({
      bg = "#121212",
      -- violet = "#ff74b8",
    })
    vim.cmd([[colorscheme moonfly]])
  end,
}
