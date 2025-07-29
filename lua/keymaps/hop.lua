return {
  ["aoj"] = {
    function()
      require("hop").hint_words({ direction = 2, hint_position = 3 })
    end,
    { "n", "x" },
  },
  ["aok"] = {
    function()
      require("hop").hint_words({ direction = 1, hint_position = 3 })
    end,
    { "n", "x" },
  },
  ["<space><space>o"] = {
    function()
      require("hop").hint_words({ hint_position = 3 })
    end,
    { "n", "x" },
  },
  ["aij"] = {
    function()
      require("hop").hint_words({ direction = 2, hint_position = 1 })
    end,
    { "n", "x" },
  },
  ["aik"] = {
    function()
      require("hop").hint_words({ direction = 1, hint_position = 1 })
    end,
    { "n", "x" },
  },
  ["<space><space>i"] = {
    function()
      require("hop").hint_words({ hint_position = 1 })
    end,
    { "n", "x" },
  },
  ["ail"] = {
    function()
      require("hop").hint_words({ hint_position = 1, current_line_only = true, direction = 2 })
    end,
    { "n", "x" },
  },
  ["aih"] = {
    function()
      require("hop").hint_words({ hint_position = 1, current_line_only = true, direction = 1 })
    end,
    { "n", "x" },
  },
  ["aol"] = {
    function()
      require("hop").hint_words({ hint_position = 3, current_line_only = true, direction = 2 })
    end,
    { "n", "x" },
  },
  ["aoh"] = {
    function()
      require("hop").hint_words({ hint_position = 3, current_line_only = true, direction = 1 })
    end,
    { "n", "x" },
  },
  ["aoo"] = {
    function()
      require("hop").hint_words({ hint_position = 3 })
    end,
    { "n", "x" },
  },
  ["aii"] = {
    function()
      require("hop").hint_words({ hint_position = 1 })
    end,
    { "n", "x" },
  },
  -- ["0o"] = {
  --   function()
  --     require("hop").hint_words({ hint_position = 3, current_line_only = true })
  --   end,
  --   { "n", "x" }
  -- },
  -- ["0i"] = {
  --   function()
  --     require("hop").hint_words({ hint_position = 1, current_line_only = true })
  --   end,
  --   { "n", "x" }
  -- },
  ["00o"] = {
    function()
      require("hop").hint_words({ hint_position = 3 })
    end,
    { "n", "x" },
  },
  ["00i"] = {
    function()
      require("hop").hint_words({ hint_position = 1 })
    end,
    { "n", "x" },
  },
}
