return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/simple-keymap.nvim",
  name = "simple-keymap",
  config = function()
    require("simple-keymap").setup({
      add = {
        "keymaps/",
        "keymaps/select-mode",
        "test",
      },
      del = {
        ["in"] = { "x" },
        ["d0i"] = { "n" },
        ["d0o"] = { "n" },
      },
    })
  end,
}
