return {
  "olimorris/onedarkpro.nvim",
  lazy = false,
  priority = 1000, -- Ensure it loads first
  config = function()
    vim.cmd("colorscheme onedark_dark")
  end,
}
