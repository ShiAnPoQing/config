return {
  "rmehri01/onenord.nvim",
  lazy = false,
  enabled = true,
  config = function()
    require("onenord").setup()
    vim.cmd("colorscheme onenord")
  end,
}
