return {
  ["<C-right>"] = {
    function()
      require("custom.plugins.insert-mode-move-word").move_word("right")
    end,
    { "i", "n" },
  },
  ["<C-left>"] = {
    function()
      require("custom.plugins.insert-mode-move-word").move_word("left")
    end,
    { "i", "n" },
  },
}
