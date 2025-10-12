return {
  name = "concat-line",
  keys = {
    ["<space>-"] = {
      function()
        require("concat-line").line_concat({ join_char = " " })
        require("repeat"):set(function()
          require("concat-line").line_concat({ join_char = " " })
          vim.api.nvim_feedkeys("g@", "nx", false)
        end)
        return "g@"
      end,
      { "n", "x" },
      expr = true,
    },
    ["<space>--"] = {
      function()
        require("concat-line").line_concat({ join_char = " " })
        require("repeat"):set(function()
          require("concat-line").line_concat({ join_char = " " })
          vim.api.nvim_feedkeys("g@_", "nx", false)
        end)
        return "g@_"
      end,
      "n",
      expr = true,
    },
    ["g<space>-"] = {
      function()
        require("concat-line").line_concat({ trim_blank = false })
        require("repeat"):set(function()
          require("concat-line").line_concat({ trim_blank = false })
          vim.api.nvim_feedkeys("g@", "nx", false)
        end)
        return "g@"
      end,
      { "n", "x" },
      expr = true,
    },
    ["g<space>--"] = {
      function()
        require("concat-line").line_concat({ trim_blank = false })
        require("repeat"):set(function()
          require("concat-line").line_concat({ trim_blank = false })
          vim.api.nvim_feedkeys("g@_", "nx", false)
        end)
        return "g@_"
      end,
      { "n" },
      expr = true,
    },
  },
  config = function()
    require("concat-line").setup()
  end,
}
