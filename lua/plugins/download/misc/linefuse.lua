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
      desc = "Join lines",
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
      desc = "Join One Line",
    },
    ["g-"] = {
      function()
        require("linefuse").linefuse({ trim_blank = false })
        return "g@"
      end,
      { "n", "x" },
      expr = true,
      desc = "Join lines[not trim blank]",
    },
    ["g--"] = {
      function()
        require("linefuse").linefuse({ trim_blank = false })
        return "g@j"
      end,
      "n",
      expr = true,
      desc = "Join One Line[not trim blank]",
    },
  },
  config = function()
    require("linefuse").setup()
  end,
}
