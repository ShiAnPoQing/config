local Repeat = require("repeat")

return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/move-line",
  name = "move-line",
  keys = {
    {
      "<C-down>",
      function()
        require("move-line").move_line({
          dir = "down",
        })
        Repeat.record({
          name = "move-line",
          callback = function()
            require("move-line").move_line({
              dir = "down",
            })
          end,
        })
      end,
      mode = { "n", "i", "x" },
    },
    {
      "<C-up>",
      function()
        require("move-line").move_line({
          dir = "up",
        })
        Repeat.record({
          name = "move-line",
          callback = function()
            require("move-line").move_line({
              dir = "up",
            })
          end,
        })
      end,
      mode = { "n", "i", "x" },
    },
  },
  config = function()
    require("move-line").setup({})
  end,
}
