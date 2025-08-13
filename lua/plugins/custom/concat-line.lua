return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/concat-line",
  name = "concat-line",
  keys = {
    {
      "<space>-",
      function()
        require("concat-line").line_concat({ join_char = " " })
        require("repeat").record({
          name = "line_concat",
          callback = function()
            require("concat-line").line_concat({
              join_char = " ",
            })
            vim.api.nvim_feedkeys("g@", "nx", false)
          end,
        })
        return "g@"
      end,
      expr = true,
    },
    {
      "<space>--",
      function()
        require("concat-line").line_concat({
          join_char = " ",
        })
        require("repeat").record({
          name = "line_concat",
          callback = function()
            require("concat-line").line_concat({
              join_char = " ",
            })
            vim.api.nvim_feedkeys("g@_", "nx", false)
          end,
        })
        return "g@_"
      end,
      expr = true,
    },

    {
      "g<space>-",
      function()
        require("concat-line").line_concat({ trim_blank = false })
        require("repeat").record({
          name = "line_concat",
          callback = function()
            require("concat-line").line_concat({ trim_blank = false })
            vim.api.nvim_feedkeys("g@", "nx", false)
          end,
        })
        return "g@"
      end,
      mode = { "n", "x" },
      expr = true,
    },
    {
      "g<space>--",
      function()
        require("concat-line").line_concat({ trim_blank = false })
        require("repeat").record({
          name = "line_concat",
          callback = function()
            require("concat-line").line_concat({ trim_blank = false })
            vim.api.nvim_feedkeys("g@_", "nx", false)
          end,
        })
        return "g@_"
      end,
      mode = { "n" },
      expr = true,
    },
  },
  config = function(opt)
    require("concat-line").setup()
  end,
}
