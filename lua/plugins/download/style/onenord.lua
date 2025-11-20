return {
  "rmehri01/onenord.nvim",
  priority = 1000,
  lazy = true,
  -- colorscheme = "onenord",
  config = function()
    require("onenord").setup()
    vim.cmd("colorscheme onenord")
  end,
}
