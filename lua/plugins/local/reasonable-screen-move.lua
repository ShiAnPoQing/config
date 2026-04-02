return {
  name = "reasonable-screen-move.nvim",
  depend = {
    "reasonable-scroll.nvim",
    "BrokenSunny/repeat.nvim",
  },
  key = {
    ["ah"] = {
      function()
        local function callback()
          require("reasonable-screen-move").first_non_blank_character()
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      { "n", "x", "o" },
      desc = "Screen Line First Non Blank Character",
    },
    ["al"] = {
      function()
        local function callback()
          require("reasonable-screen-move").last_non_blank_character()
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      { "n", "x", "o" },
      desc = "Screen Line Last Non Blank Character",
    },
    ["ak"] = {
      function()
        local function callback()
          require("reasonable-screen-move").top()
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      { "n", "x", "o" },
      desc = "Screen Top",
    },
    ["aj"] = {
      function()
        local function callback()
          require("reasonable-screen-move").bottom()
          require("repeat").set_motion(callback)
        end
        callback()
      end,
      { "n", "x", "o" },
      desc = "Screen Bottom",
    },
    ["am"] = {
      "gm",
      { "n", "x", "o" },
      desc = "Screen Horizontally Center",
    },
    ["an"] = {
      "M",
      { "n", "x", "o" },
      desc = "Screen Vertical Center",
    },
    ["ac"] = {
      "gmM",
      "n",
      desc = "Screen Center",
    },
    ["aak"] = {
      function()
        require("reasonable-screen-move").top()
      end,
      { "n", "x", "o" },
      desc = "Screen Top",
    },
    ["aaj"] = {
      function()
        require("reasonable-screen-move").bottom()
      end,
      { "n", "x", "o" },
      desc = "Screen Bottom",
    },
    ["aah"] = {
      {
        function()
          require("reasonable-screen-move").first_character()
        end,
        { "n", "x" },
      },
      { "g0", "o" },
      desc = "Screen Line First Character",
    },
    ["aal"] = {
      {
        function()
          require("reasonable-screen-move").last_character()
        end,
        { "n", "x" },
      },
      { "g$", "o" },
      desc = "Screen Line Last Character",
    },
  },
}
