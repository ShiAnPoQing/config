return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/simple-keymap.nvim",
  name = "simple-keymap",
  config = function()
    require("simple-keymap").setup({
      add = {
        "keymaps/",
      },
    })
  end,
}
