return {
  -- line connect
  ["<space><space><BS>"] = {
    function()
      local L = require("line-connect")
      local count = vim.v.count1
      L.LineConnect(count, "n", "al")
      vim.api.nvim_feedkeys("_", "n", false)

      require("repeat").Record(function()
        L.LineConnect(count, "n", "al")
        vim.api.nvim_feedkeys("_", "n", false)
      end)
    end,
    { "n" },
    { expr = true },
  },
  -- @line connect + move
  ["<space><BS>"] = {
    {
      function()
        local L = require("line-connect")
        local count = vim.v.count1
        L.LineConnect(count, "n", "")
        require("repeat").Record(function()
          L.LineConnect(count, "n", "")
        end)
      end,
      "n",
      { expr = true },
    },
    {
      function()
        local L = require("line-connect")
        local count = vim.v.count1
        L.LineConnect(count, "x", "al")
        require("repeat").Record(function()
          L.LineConnect(count, "x", "al")
        end)
      end,
      { "x" },
      { expr = true },
    },
  },
  -- Line Break
  ["<space><CR>"] = {
    {
      function()
        local L = require("line-break")
        local count = vim.v.count1
        L.LineBreak(count, "n", "al")
        require("repeat").Record(function()
          L.LineBreak(count, "n", "al")
        end)
      end,
      { "n" },
      { expr = true },
    },
    {
      function()
        local L = require("line-break")
        local count = vim.v.count1
        L.LineBreak(count, "v", "al")
        require("repeat").Record(function()
          L.LineBreak(count, "v", "al")
        end)
      end,
      { "x" },
      { expr = true },
    },
  },
  ["<leader>sl"] = {
    {
      function()
        local S = require("custom.plugins.sort-line")
        S.sortLineByLength("n")
        require("repeat").Record(function()
          S.sortLineByLength("n")
        end)
      end,
      "n",
    },
    {
      function()
        local S = require("custom.plugins.sort-line")
        S.sortLineByLength("v")
        require("repeat").Record(function()
          S.sortLineByLength("v")
        end)
      end,
      "x",
    },
  },

  ["Q"] = {
    { "gwap", { "n" } },
    { "gw",   { "x" } },
  },
}
