local select_move = require("custom.plugins.move-select")

return {
  ["<C-space><C-l>"] = {
    function()
      select_move.select_start_end_move("right")
    end,
    "s",
  },
  ["<C-space><C-h>"] = {
    function()
      select_move.select_start_end_move("left")
    end,
    "s",
  },
  ["<C-o>"] = {
    function()
      select_move.select_word_move("right")
    end,
    "s",
  },
  ["<C-i>"] = {
    function()
      select_move.select_word_move("left")
    end,
    "s",
  },
}
