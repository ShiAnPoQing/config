local move_line = require("custom.plugins.move-line")

return {
  -- move line(s): Down
  ["<C-down>"] = {
    {
      function()
        move_line.moveLine("down")
        require("repeat").Record(function()
          move_line.moveLine("down")
        end)
      end,
      { "n", "i", "x" },
    },
  },
  -- move line(s): Up
  ["<C-up>"] = {
    {
      function()
        move_line.moveLine("up")
        require("repeat").Record(function()
          move_line.moveLine("up")
        end)
      end,
      { "n", "i", "x" },
    },
  },
}
