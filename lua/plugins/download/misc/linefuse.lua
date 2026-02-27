return {
  "BrokenSunny/linefuse.nvim",
  key = {
    ["-"] = {
      function()
        require("linefuse").linefuse({ join_char = " " })
        return "g@"
      end,
      { "n", "x" },
      expr = true,
    },
    ["--"] = {
      {
        function()
          require("linefuse").linefuse({ join_char = " " })
          return "g@j"
        end,
        "n",
        expr = true,
        exclude_ft = "oil",
      },
    },
    ["g-"] = {
      function()
        require("linefuse").linefuse({ trim_blank = false })
        return "g@"
      end,
      { "n", "x" },
      expr = true,
    },
    ["g--"] = {
      function()
        require("linefuse").linefuse({ trim_blank = false })
        return "g@j"
      end,
      "n",
      expr = true,
    },
  },
  config = function()
    require("linefuse").setup()
  end,
}
