return {
  name = "simple-keymap.nvim",
  config = function()
    require("simple-keymap").setup({
      add = {
        "keymaps/",
        "keymaps/select-mode",
        "test",
      },
      del = {
        ["in"] = { "x" },
        ["d0i"] = { "n", "x", "o" },
        ["d0o"] = { "n", "x", "o" },
        ["v0i"] = { "n", "x", "o" },
        ["v0o"] = { "n", "x", "o" },
      },
    })
  end,
}
