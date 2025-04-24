local clone = require("custom.plugins.clone-word")

return {
  -- clone up line with word step
  ["<M-S-w>"] = {
    {
      function()
        local count = vim.v.count1
        clone.copy_line_word("up", count, "i")
        require("repeat").Record(function()
          clone.copy_line_word("up", count, "i")
        end)
      end,
      "i",
    },

    {
      function()
        local count = vim.v.count1
        clone.copy_line_word("up", count, "n")
        require("repeat").Record(function()
          clone.copy_line_word("up", count, "n")
        end)
      end,
      "n",
    },
  },
  -- clone down line with word step
  ["<M-S-e>"] = {
    {
      function()
        local count = vim.v.count1
        clone.copy_line_word("down", count, "i")
        require("repeat").Record(function()
          clone.copy_line_word("down", count, "i")
        end)
      end,
      "i",
    },
    {
      function()
        local count = vim.v.count1
        clone.copy_line_word("down", count, "n")
        require("repeat").Record(function()
          clone.copy_line_word("down", count, "n")
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
