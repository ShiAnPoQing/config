return {
  "bluz71/vim-moonfly-colors",
  priority = 1000,
  lazy = true,
  -- colorscheme = "moonfly",
  config = function()
    vim.g.moonflyTransparent = true
    vim.g.moonflyVirtualTextColor = true
    require("moonfly").custom_colors({
      -- bg = "#000000",
      -- violet = "#ff74b8",
    })
    vim.cmd([[colorscheme moonfly]])
  end,
}
