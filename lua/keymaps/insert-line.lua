return {
  ["b"] = { "o", { "n", "x" } },
  ["B"] = { "O", { "n", "x" } },
  -- no blank
  ["<space>b"] = { "o<C-u>", { "n" } },
  -- no blank
  ["<space>B"] = { "O<C-u>", { "n" } },
  ["<S-CR>"] = {
    "<C-o>O",
    "i",
  },
  -- no blank
  ["<C-CR>"] = {
    "<CR><C-U>",
    "i",
  },
  -- no blank
  ["<C-S-CR>"] = {
    "<C-o>O<C-U>",
    "i",
  },
  ["<C-b>"] = {
    function()
      require("custom.plugins.insert-line").insert_line({
        dir = "above",
        cursor = "move",
      })
      require("repeat").record({
        name = "insert-line",
        callback = function()
          require("custom.plugins.insert-line").insert_line({
            dir = "above",
            cursor = "move",
          })
        end,
      })
    end,
    "n",
  },
  ["<M-b>"] = {
    function()
      require("custom.plugins.insert-line").insert_line({
        dir = "below",
        cursor = "move",
      })
      require("repeat").record({
        name = "insert-line",
        callback = function()
          require("custom.plugins.insert-line").insert_line({
            dir = "below",
            cursor = "move",
          })
        end,
      })
    end,
    "n",
  },
  ["<C-M-b>"] = {
    function()
      require("custom.plugins.insert-line").insert_line({
        dir = "all",
        cursor = "move",
      })
      require("repeat").record({
        name = "insert-line",
        callback = function()
          require("custom.plugins.insert-line").insert_line({
            dir = "all",
            cursor = "move",
          })
        end,
      })
    end,
    "n",
  },
  ["<space><C-b>"] = {
    function()
      require("custom.plugins.insert-line").insert_line({
        dir = "above",
        cursor = "keep",
      })
      require("repeat").record({
        name = "insert-line",
        callback = function()
          require("custom.plugins.insert-line").insert_line({
            dir = "above",
            cursor = "keep",
          })
        end,
      })
    end,
    "n",
  },
  ["<space><M-b>"] = {
    function()
      require("custom.plugins.insert-line").insert_line({
        dir = "below",
        cursor = "keep",
      })
      require("repeat").record({
        name = "insert-line",
        callback = function()
          require("custom.plugins.insert-line").insert_line({
            dir = "below",
            cursor = "keep",
          })
        end,
      })
    end,
    "n",
  },
}
