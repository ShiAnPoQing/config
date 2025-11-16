return {
  name = "concat-line",
  keys = {
    ["-"] = {
      function()
        require("concat-line").line_concat({ join_char = " " })
        return "g@"
      end,
      { "n", "x" },
      expr = true,
    },
    ["--"] = {
      function()
        require("concat-line").line_concat({ join_char = " " })
        return "g@_"
      end,
      { "n", "x" },
      expr = true,
    },
    ["g-"] = {
      function()
        require("concat-line").line_concat({ trim_blank = false })
        return "g@"
      end,
      { "n", "x" },
      expr = true,
    },
    ["g--"] = {
      function()
        require("concat-line").line_concat({ trim_blank = false })
        return "g@_"
      end,
      { "n", "x" },
      expr = true,
    },
  },
  config = function()
    require("concat-line").setup()
  end,
}
