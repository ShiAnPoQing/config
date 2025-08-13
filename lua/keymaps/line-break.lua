local line_break = require("custom.plugins.line-break")
local Repeat = require("repeat")

return {
  -- Line Break
  ["<space><CR>"] = {
    {
      function()
        line_break.line_break(vim.v.count1)
        Repeat.record({
          name = "line_break",
          callback = function()
            line_break.line_break(vim.v.count1)
          end,
        })
      end,
      { "n", "x" },
      { expr = true },
    },
  },
}

-- line connect
-- ["<space><space><BS>"] = {
--   function()
--     local L = require("line-connect")
--     local count = vim.v.count1
--     L.LineConnect(count, "n", "al")
--     vim.api.nvim_feedkeys("_", "n", false)
--
--   end,
--   { "n" },
--   { expr = true },
-- },
-- @line connect + move
-- ["<space><BS>"] = {
--   {
--     function()
--       require("custom.plugins.line-connect").line_concat()
--     end,
--     { "n",        "x" },
--     { expr = true },
--   },
--   -- {
--   --   function()
--   --     local L = require("line-connect")
--   --     local count = vim.v.count1
--   --     L.LineConnect(count, "x", "al")
--   --   end,
--   --   { "x" },
--   --   { expr = true },
--   -- },
-- },
-- Line Break
-- ["<space><CR>"] = {
--   {
--     function()
--       local L = require("line-break")
--       local count = vim.v.count1
--       L.LineBreak(count, "n", "al")
--       require("repeat").Record(function()
--         L.LineBreak(count, "n", "al")
--       end)
--     end,
--     { "n" },
--     { expr = true },
--   },
--   {
--     function()
--       local L = require("line-break")
--       local count = vim.v.count1
--       L.LineBreak(count, "v", "al")
--       require("repeat").Record(function()
--         L.LineBreak(count, "v", "al")
--       end)
--     end,
--     { "x" },
--     { expr = true },
--   },
-- },
