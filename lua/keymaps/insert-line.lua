return {
  ["b"] = { "o", { "n", "x" } },
  ["B"] = { "O", { "n", "x" } },
  -- no blank
  ["<space>b"] = { "o<C-u>", { "n" } },
  -- no blank
  ["<space>B"] = { "O<C-u>", { "n" } },
  -- no blank
  ["<S-CR>"] = {
    "<CR><C-U>",
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
    { "n", "i" },
  },
  ["<C-space><C-b>"] = {
    function()
      require("custom.plugins.insert-line").insert_line({
        dir = "above",
        cursor = "move",
        indent = false,
      })
      require("repeat").record({
        name = "insert-line",
        callback = function()
          require("custom.plugins.insert-line").insert_line({
            dir = "above",
            cursor = "move",
            indent = false,
          })
        end,
      })
    end,
    "i",
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
    { "n", "i" },
  },
  ["<M-space><M-b>"] = {
    function()
      require("custom.plugins.insert-line").insert_line({
        dir = "below",
        cursor = "move",
        indent = false,
      })
      require("repeat").record({
        name = "insert-line",
        callback = function()
          require("custom.plugins.insert-line").insert_line({
            dir = "below",
            cursor = "move",
            indent = false,
          })
        end,
      })
    end,
    "i",
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
    { "n", "i" },
  },
  ["<C-S-b>"] = {
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
    { "n", "i" },
  },
  ["<M-S-b>"] = {
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
    { "n", "i" },
  },
}
