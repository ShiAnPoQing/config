return {
  dir = "~/.config/nvim/pack/custom/opt/concat-line",
  keys = {
    {
      "-",
      function()
        require("concat-line").line_concat({ join_char = " " })
        return "g@"
      end,
      mode = { "n", "x" },
      expr = true,
    },
    {
      "--",
      function()
        require("concat-line").line_concat({ join_char = " " })
        return "g@j"
      end,
      expr = true,
    },
    {
      "g-",
      function()
        require("concat-line").line_concat({ trim_blank = false })
        return "g@"
      end,
      mode = { "n", "x" },
      expr = true,
    },
    {
      "g--",
      function()
        require("concat-line").line_concat({ trim_blank = false })
        return "g@j"
      end,
      expr = true,
    },
  },
  config = function()
    require("concat-line").setup()
  end,
}
