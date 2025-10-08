return {
  ["0<C-up>"] = {
    function()
      require("magic").magic_move_line("up")
    end,
    { "n", "x" },
  },
  ["0<C-down>"] = {
    function()
      require("magic").magic_move_line("down")
    end,
    { "n", "x" },
  },
}
