return {
  "rmehri01/onenord.nvim",
  priority = 1000,
  colorscheme = "onenord",
  config = function()
    require("onenord").setup()
    vim.cmd("colorscheme onenord")
  end,
}
