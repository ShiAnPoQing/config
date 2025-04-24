return {
  -- move line(s): Down
  ["<C-down>"] = {
    {
      function()
        local L = require("move-line")
        local count = vim.v.count1
        L.moveLine(count, "down")
        require("repeat").Record(function()
          L.moveLine(count, "down")
        end)
      end,
      { "n", "i" },
    },
    {
      function()
        local L = require("move-line")
        local count = vim.v.count1
        L.moveLineVisualMode(count, "down")
        require("repeat").Record(function()
          L.moveLineVisualMode(count, "down")
        end)
      end,
      { "x" },
    },
  },
  -- move line(s): Up
  ["<C-up>"] = {
    {
      function()
        local L = require("move-line")
        local count = vim.v.count1
        L.moveLine(count, "up")
        require("repeat").Record(function()
          L.moveLine(count, "up")
        end)
      end,
      { "n", "i" },
    },
    {
      function()
        local L = require("move-line")
        local count = vim.v.count1
        L.moveLineVisualMode(count, "up")
        require("repeat").Record(function()
          L.moveLineVisualMode(count, "up")
        end)
      end,
      { "x" },
    },
  },
  -- add new line above current line and into insert mode
  ["<space>b"] = { "o<C-u>", { "n" } },
  -- add new line below current line and into insert mode
  ["<space>B"] = { "O<C-u>", { "n" } },

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
        local S = require("sort-line")
        S.sortLineByLength("n")
        require("repeat").Record(function()
          S.sortLineByLength("n")
        end)
      end,
      "n",
    },
    {
      function()
        local S = require("sort-line")
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
