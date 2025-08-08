local line_concat = require("custom.plugins.line-concat")
local R = require("repeat")

return {
  ["<space>-"] = {
    function()
      line_concat.line_concat({
        join_char = " ",
      })
      R.record({
        name = "line_concat",
        callback = function()
          line_concat.line_concat({
            join_char = " ",
          })
          vim.api.nvim_feedkeys("g@", "nx", false)
        end,
      })
      return "g@"
    end,
    { "n", "x" },
    { expr = true },
  },
  ["<space>--"] = {
    function()
      line_concat.line_concat({
        join_char = " ",
      })
      R.record({
        name = "line_concat",
        callback = function()
          line_concat.line_concat({
            join_char = " ",
          })
          vim.api.nvim_feedkeys("g@_", "nx", false)
        end,
      })
      return "g@_"
    end,
    { "n" },
    { expr = true },
  },
  ["g<space>-"] = {
    function()
      line_concat.line_concat({ trim_blank = false })
      R.record({
        name = "line_concat",
        callback = function()
          line_concat.line_concat({ trim_blank = false })
          vim.api.nvim_feedkeys("g@", "nx", false)
        end,
      })
      return "g@"
    end,
    { "n", "x" },
    { expr = true },
  },
  ["g<space>--"] = {
    function()
      line_concat.line_concat({ trim_blank = false })
      R.record({
        name = "line_concat",
        callback = function()
          line_concat.line_concat({ trim_blank = false })
          vim.api.nvim_feedkeys("g@_", "nx", false)
        end,
      })
      return "g@_"
    end,
    { "n" },
    { expr = true },
  },
  ["<space>-i"] = {
    function()
      line_concat.line_concat({
        trim_blank = false,
        input = true,
      })
      return "g@"
    end,
    { "n", "x" },
    { expr = true },
  },
}
