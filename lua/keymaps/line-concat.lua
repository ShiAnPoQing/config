local line_concat = require("custom.plugins.line-concat")
local R = require("repeat")

return {
  ["<space><bs>"] = {
    function()
      line_concat.line_concat()
      R.Record(function()
        line_concat.line_concat()
        vim.api.nvim_feedkeys("g@", "nx", false)
      end)
      return "g@"
    end,
    { "n",        "x" },
    { expr = true }
  },
  ["<space><space><bs>"] = {
    function()
      line_concat.line_concat()
      R.Record(function()
        line_concat.line_concat()
        vim.api.nvim_feedkeys("g@_", "nx", false)
      end)
      return "g@_"
    end,
    { "n",        "x" },
    { expr = true }
  }
}
