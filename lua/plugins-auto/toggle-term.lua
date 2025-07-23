return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { ";tm", "<cmd>ToggleTerm<cr>", desc = "Toggle Term" }
  },
  config = function()
    require("toggleterm").setup({
      open_mapping = [[;tm]],
      close_on_exit = true,
      shell = vim.o.shell,
      -- direction = 'vertical' | 'horizontal' | 'tab' | 'float'
      direction = "horizontal",
    })
  end,
}
