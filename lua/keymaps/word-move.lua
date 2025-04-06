return {
  ["<space>i"] = { "ge", { "n", "x", "o" } },
  ["<space>I"] = { "gE", { "n", "x", "o" } },
  ["<space>o"] = { "w", { "n", "x", "o" } },
  ["<space>O"] = { "W", { "n", "x", "o" } },
  ["i"] = {
    {
      function()
        local count = vim.v.count
        require("base-function").normalModeWordLeftMove(count)
        require("repeat").Record(function()
          require("base-function").normalModeWordLeftMove(count)
        end)
      end,
      "n",
      { desc = "word left move" },
    },
    {
      function()
        local count = vim.v.count1
        require("base-function").OmodeWordLeftMove(count)
        require("repeat").Record(function()
          require("base-function").OmodeWordLeftMove(count)
        end)
      end,
      "o",
      { desc = "word left move" },
    },
    { "b", { "x" }, { desc = "word left move" } },
  },
  ["o"] = {
    {
      function()
        local count = vim.v.count
        require("base-function").normalModeWordRightMove(count)
        require("repeat").Record(function()
          require("base-function").normalModeWordRightMove(count)
        end)
      end,
      "n",
      { desc = "word right move" },
    },
    {
      "e",
      { "x",                     "o" },
      { desc = "word right move" },
    },
  },
  ["I"] = {
    {
      function()
        local count = vim.v.count
        require("base-function").normalModeWORDLeftMove(count)
        require("repeat").Record(function()
          require("base-function").normalModeWORDLeftMove(count)
        end)
      end,
      "n",
      { desc = "WORD left move" },
    },
    {
      "B",
      { "x",                    "o" },
      { desc = "WORD left move" },
    },
  },
  ["O"] = {
    {
      function()
        local count = vim.v.count
        require("base-function").normalModeWORDRightMove(count)
        require("repeat").Record(function()
          require("base-function").normalModeWORDRightMove(count)
        end)
      end,
      "n",
      { desc = "WORD right move" },
    },
    { "E", { "x", "o" }, { desc = "WORD right move" } },
  },
}
