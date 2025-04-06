return {
  -- clone up line with word step
  ["<M-S-w>"] = {
    {
      function()
        local M = require("copy-line-word")
        local count = vim.v.count1
        M.CopyLineWord("up", count, "i")
        require("repeat").Record(function()
          M.CopyLineWord("up", count, "i")
        end)
      end,
      "i",
    },

    {
      function()
        local M = require("copy-line-word")
        local count = vim.v.count1
        M.CopyLineWord("up", count, "n")
        require("repeat").Record(function()
          M.CopyLineWord("up", count, "n")
        end)
      end,
      "n",
    },
  },
  -- clone down line with word step
  ["<M-S-e>"] = {
    {
      function()
        local M = require("copy-line-word")
        local count = vim.v.count1
        M.CopyLineWord("down", count, "i")
        require("repeat").Record(function()
          M.CopyLineWord("down", count, "i")
        end)
      end,
      "i",
    },
    {
      function()
        local M = require("copy-line-word")
        local count = vim.v.count1
        M.CopyLineWord("down", count, "n")
        require("repeat").Record(function()
          M.CopyLineWord("down", count, "n")
        end)
      end,
      "n",
    },
  },
  -- clone up line with single letter
  ["<M-w>"] = {
    "<C-y>",
    "i",
  },
  -- clone down line with single letter
  ["<M-e>"] = {
    "<C-e>",
    "i",
  },
}
