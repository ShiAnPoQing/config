return {
  name = "concat-line",
  key = {
    ["-"] = {
      function()
        require("concat-line").line_concat({ join_char = " " })
        return "g@"
      end,
      { "n", "x" },
      expr = true,
    },
    ["--"] = {
      {
        function()
          require("concat-line").line_concat({ join_char = " " })
          return "g@j"
        end,
        "n",
        expr = true,
        exclude_ft = "oil",
      },
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
        return "g@j"
      end,
      "n",
      expr = true,
    },
  },
  config = function()
    require("concat-line").setup()
  end,
}
