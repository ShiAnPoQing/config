return {
  "rmehri01/onenord.nvim",
  lazy = true,
  enabled = true,
  config = function()
    require("onenord").setup()
    vim.cmd("colorscheme onenord")
  end,
}
