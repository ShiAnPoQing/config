return {
  ["n"] = {
    "o",
    {
      { "n", desc = "Begin a new line below the cursor and insert text" },
      { "x", desc = "Go to Other end of highlighted text" },
    },
  },
  ["N"] = {
    "O",
    {
      { "n", desc = "Begin a new line above the cursor and insert text" },
      { "x", desc = "Go to Other end of highlighted text" },
    },
  },
  -- no blank
  ["<space>n"] = {
    "o^<C-d>",
    "n",
    desc = "Begin a new line below the cursor and insert text(non-blank)",
  },
  -- no blank
  ["<space>N"] = {
    "O^<C-d>",
    "n",
    desc = "Begin a new line above the cursor and insert text(non-blank)",
  },
  -- no blank
  ["<S-CR>"] = {
    "<CR><C-U>",
    "i",
    desc = "Begin new line(non-blank)",
  },
  ["<C-n>"] = {
    function()
      local function insert_line()
        require("builtin.insert-line").insert_line({
          dir = "above",
          cursor = "move",
          after = function()
            require("repeat"):set(insert_line)
          end,
        })
      end
      insert_line()
    end,
    { "n", "i" },
    desc = "Above insert new line(cursor follow)",
  },
  ["<C-space><C-n>"] = {
    function()
      local function insert_line()
        require("builtin.insert-line").insert_line({
          dir = "above",
          cursor = "move",
          indent = false,
          after = function()
            require("repeat"):set(insert_line)
          end,
        })
      end
      insert_line()
    end,
    "i",
    desc = "Above insert new line(cursor follow)(no indent)",
  },
  ["<M-n>"] = {
    function()
      local function insert_line()
        require("builtin.insert-line").insert_line({
          dir = "below",
          cursor = "move",
          after = function()
            require("repeat"):set(insert_line)
          end,
        })
      end
      insert_line()
    end,
    { "n", "i" },
    desc = "Below insert new line(cursor follow)",
  },
  ["<M-space><M-n>"] = {
    function()
      local function insert_line()
        require("builtin.insert-line").insert_line({
          dir = "below",
          cursor = "move",
          indent = false,
          after = function()
            require("repeat"):set(insert_line)
          end,
        })
      end
      insert_line()
    end,
    "i",
    desc = "Below insert new line(cursor follow)(no indent)",
  },
  ["<C-M-n>"] = {
    function()
      local function insert_line()
        require("builtin.insert-line").insert_line({
          dir = "all",
          cursor = "move",
          after = function()
            require("repeat"):set(insert_line)
          end,
        })
      end
      insert_line()
    end,
    { "n", "i" },
    desc = "Below and Above insert new line",
  },
  ["<C-S-n>"] = {
    function()
      local function insert_line()
        require("builtin.insert-line").insert_line({
          dir = "above",
          cursor = "keep",
          after = function()
            require("repeat"):set(insert_line)
          end,
        })
      end
      insert_line()
    end,
    { "n", "i" },
    desc = "Above insert new line(cursor don't follow)",
  },
  ["<M-S-n>"] = {
    function()
      local function insert_line()
        require("builtin.insert-line").insert_line({
          dir = "below",
          cursor = "keep",
          after = function()
            require("repeat"):set(insert_line)
          end,
        })
      end
      insert_line()
    end,
    { "n", "i" },
    desc = "Below insert new line(cursor don't follow)",
  },
}
