local move_line = require("custom.plugins.move-line")
local Repeat = require("repeat")

return {
  -- move line(s): Down
  ["<C-down>"] = {
    {
      function()
        move_line.move_line("down")
        Repeat.record({
          name = "move-line",
          callback = function()
            move_line.move_line("down")
          end,
        })
      end,
      { "n", "i", "x" },
    },
  },
  -- move line(s): Up
  ["<C-up>"] = {
    {
      function()
        move_line.move_line("up")
        Repeat.record({
          name = "move-line",
          callback = function()
            move_line.move_line("up")
          end,
        })
      end,
      { "n", "i", "x" },
    },
  },
}
