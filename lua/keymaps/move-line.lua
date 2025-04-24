local move_line = require("custom.plugins.move-line")

return {
  -- move line(s): Down
  ["<C-down>"] = {
    {
      function()
        local count = vim.v.count1
        move_line.moveLine(count, "down")
        require("repeat").Record(function()
          move_line.moveLine(count, "down")
        end)
      end,
      { "n", "i" },
    },
    {
      function()
        local count = vim.v.count1
        move_line.moveLineVisualMode(count, "down")
        require("repeat").Record(function()
          move_line.moveLineVisualMode(count, "down")
        end)
      end,
      { "x" },
    },
  },
  -- move line(s): Up
  ["<C-up>"] = {
    {
      function()
        local count = vim.v.count1
        move_line.moveLine(count, "up")
        require("repeat").Record(function()
          move_line.moveLine(count, "up")
        end)
      end,
      { "n", "i" },
    },
    {
      function()
        local count = vim.v.count1
        move_line.moveLineVisualMode(count, "up")
        require("repeat").Record(function()
          move_line.moveLineVisualMode(count, "up")
        end)
      end,
      { "x" },
    },
  },
}
