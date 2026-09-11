return {
  "BrokenSunny/repeat.nvim",
  config = function()
    require("repeat").setup({
      keymap = {
        undoline = "<space>u",
        redo = "U",
      },
    })
  end,
}
