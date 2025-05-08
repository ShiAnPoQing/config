local line_break = require("custom.plugins.line-break")

return {
  -- Line Break
  ["<space><CR>"] = {
    {
      function()
        line_break.line_break(vim.v.count1)
      end,
      "n",
      { expr = true },
    },
    -- {
    --   function()
    --     local L = require("line-break")
    --     local count = vim.v.count1
    --     L.LineBreak(count, "v", "al")
    --     require("repeat").Record(function()
    --       L.LineBreak(count, "v", "al")
    --     end)
    --   end,
    --   { "x" },
    --   { expr = true },
    -- },
  },
}
