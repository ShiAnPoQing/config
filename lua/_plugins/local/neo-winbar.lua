return {
  name = "neo-winbar.nvim",
  depend = {
    "nvim-tree/nvim-web-devicons",
    "SmiteshP/nvim-navic",
  },
  config = function()
    require("neo-winbar").setup({})
  end,
}
