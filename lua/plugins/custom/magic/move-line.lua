return {
  {
    "0<C-up>",
    function()
      require("magic").magic_move_line("up")
    end,
    mode = { "n", "x" },
  },
  {
    "0<C-down>",
    function()
      require("magic").magic_move_line("down")
    end,
    mode = { "n", "x" },
  },
}
