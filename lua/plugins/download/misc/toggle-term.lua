return {
  "akinsho/toggleterm.nvim",
  version = "*",
  keys = {
    { "<leader>tm", "<cmd>ToggleTerm<cr>", desc = "Toggle Term" },
  },
  config = function()
    require("toggleterm").setup({
      open_mapping = [[<leader>tm]],
      close_on_exit = true,
      shell = vim.o.shell,
      -- direction = 'vertical' | 'horizontal' | 'tab' | 'float'
      direction = "horizontal",
    })
  end,
}
