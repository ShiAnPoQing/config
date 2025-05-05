return {
  ["ao"] = {
    function()
      require("hop").hint_words({ direction = 2, hint_position = 3 })
    end,
    "n"
  },
  ["aao"] = {
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
  ["ai"] = {
    function()
      require("hop").hint_words({ direction = 2, hint_position = 1 })
    end,
    "n"
  },
  ["aai"] = {
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
}
