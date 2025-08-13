return {
  ["<leader>sl"] = {
    {
      function()
        local S = require("custom.plugins.line-sort")
        S.line_sort("n")
      end,
      "n",
    },
    {
      function()
        local S = require("custom.plugins.line-sort")
        S.line_sort("v")
      end,
      "x",
    },
  },

  ["Q"] = {
    { "gwap", { "n" } },
    { "gw", { "x" } },
  },
}
