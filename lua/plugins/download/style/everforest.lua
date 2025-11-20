return {
  "sainnhe/everforest",
  priority = 1000,
  lazy = true,
  config = function()
    vim.g.everforest_enable_italic = true
    vim.opt.background = "dark"
    vim.cmd.colorscheme("everforest")
  end,
}
