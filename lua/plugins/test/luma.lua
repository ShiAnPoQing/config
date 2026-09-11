return {
  name = "luma.nvim",
  config = function()
    require("luma").setup()
    vim.o.background = "dark"
    vim.cmd.colorscheme("luma")
  end,
}
