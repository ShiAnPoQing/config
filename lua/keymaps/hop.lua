return {
  ["aoj"] = {
    function()
      require("hop").hint_words({ direction = 2, hint_position = 3 })
    end,
    "n"
  },
  ["aok"] = {
    function()
      require("hop").hint_words({ direction = 1, hint_position = 3 })
    end,
    "n"
  },
  ["<space><space>o"] = {
    function()
      require("hop").hint_words({ hint_position = 3 })
    end,
    "n"
  },
  ["aij"] = {
    function()
      require("hop").hint_words({ direction = 2, hint_position = 1 })
    end,
    "n"
  },
  ["aik"] = {
    function()
      require("hop").hint_words({ direction = 1, hint_position = 1 })
    end,
    "n"
  },
  ["<space><space>i"] = {
    function()
      require("hop").hint_words({ hint_position = 1 })
    end,
    "n"
  },
  ["ail"] = {
    function()
      require("hop").hint_words({ hint_position = 1, current_line_only = true, direction = 2 })
    end,
    "n"
  },
  ["aih"] = {
    function()
      require("hop").hint_words({ hint_position = 1, current_line_only = true, direction = 1 })
    end,
    "n"
  },
  ["aol"] = {
    function()
      require("hop").hint_words({ hint_position = 3, current_line_only = true, direction = 2 })
    end,
    "n"
  },
  ["aoh"] = {
    function()
      require("hop").hint_words({ hint_position = 3, current_line_only = true, direction = 1 })
    end,
    "n"
  },
  ["aoo"] = {
    function()
      require("hop").hint_words({ hint_position = 3 })
    end,
    "n"
  },
  ["aii"] = {
    function()
      require("hop").hint_words({ hint_position = 1 })
    end,
    "n"
  }
}
