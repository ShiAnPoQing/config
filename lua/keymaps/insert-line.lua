return {
  ["b"] = {
    "o",
    {
      { "n", desc = "Begin a new line below the cursor and insert text" },
      { "x", desc = "Go to Other end of highlighted text" },
    },
  },
  ["B"] = {
    "O",
    {
      { "n", desc = "Begin a new line above the cursor and insert text" },
      { "x", desc = "Go to Other end of highlighted text" },
    },
  },
  -- no blank
  ["<space>b"] = {
    "o<C-u>",
    "n",
    desc = "Begin a new line below the cursor and insert text(non-blank)",
  },
  -- no blank
  ["<space>B"] = {
    "O<C-u>",
    "n",
    desc = "Begin a new line above the cursor and insert text(non-blank)",
  },
  -- no blank
  ["<S-CR>"] = {
    "<CR><C-U>",
    "i",
    desc = "Begin new line(non-blank)",
  },
  ["<C-b>"] = {
    function()
      require("custom.plugins.insert-line").insert_line({
        dir = "above",
        cursor = "move",
      })
      require("repeat"):set(function()
        require("custom.plugins.insert-line").insert_line({
          dir = "above",
          cursor = "move",
        })
      end)
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
      require("repeat"):set(function()
        require("custom.plugins.insert-line").insert_line({
          dir = "above",
          cursor = "move",
          indent = false,
        })
      end)
    end,
    "i",
  },
  ["<M-b>"] = {
    function()
      require("custom.plugins.insert-line").insert_line({
        dir = "below",
        cursor = "move",
      })
      require("repeat"):set(function()
        require("custom.plugins.insert-line").insert_line({
          dir = "below",
          cursor = "move",
        })
      end)
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
      require("repeat"):set(function()
        require("custom.plugins.insert-line").insert_line({
          dir = "below",
          cursor = "move",
          indent = false,
        })
      end)
    end,
    "i",
  },
  ["<C-M-b>"] = {
    function()
      require("custom.plugins.insert-line").insert_line({
        dir = "all",
        cursor = "move",
      })
      require("repeat"):set(function()
        require("custom.plugins.insert-line").insert_line({
          dir = "all",
          cursor = "move",
        })
      end)
    end,
    { "n", "i" },
  },
  ["<C-S-b>"] = {
    function()
      require("custom.plugins.insert-line").insert_line({
        dir = "above",
        cursor = "keep",
      })
      require("repeat"):set(function()
        require("custom.plugins.insert-line").insert_line({
          dir = "above",
          cursor = "keep",
        })
      end)
    end,
    { "n", "i" },
  },
  ["<M-S-b>"] = {
    function()
      require("custom.plugins.insert-line").insert_line({
        dir = "below",
        cursor = "keep",
      })
      require("repeat"):set(function()
        require("custom.plugins.insert-line").insert_line({
          dir = "below",
          cursor = "keep",
        })
      end)
    end,
    { "n", "i" },
  },
}
