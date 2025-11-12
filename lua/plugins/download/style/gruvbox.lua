return {
  "ellisonleao/gruvbox.nvim",
  priority = 1000,
  colorscheme = "gruvbox",
  config = function()
    require("gruvbox").setup({})
    vim.cmd("colorscheme gruvbox")
  end,
}
