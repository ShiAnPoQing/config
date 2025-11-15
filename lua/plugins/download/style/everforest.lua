return {
  "sainnhe/everforest",
  priority = 1000,
  colorscheme = "everforest",
  config = function()
    vim.g.everforest_enable_italic = true
    vim.opt.background = "dark"
    vim.cmd.colorscheme("everforest")
  end,
}
