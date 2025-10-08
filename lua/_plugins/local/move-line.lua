return {
  name = "move-line",
  keys = {
    ["<C-down>"] = {
      function()
        require("move-line").move_line("down")
        require("repeat"):set(function()
          require("move-line").move_line("down")
        end)
      end,
      { "n", "i", "x" },
    },
    ["<C-up>"] = {
      function()
        require("move-line").move_line("up")
        require("repeat"):set(function()
          require("move-line").move_line("up")
        end)
      end,
      { "n", "i", "x" },
    },
  },
  config = function()
    require("move-line").setup({})
  end,
}
