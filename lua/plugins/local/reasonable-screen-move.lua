return {
  name = "reasonable-screen-move.nvim",
  depend = "reasonable-scroll.nvim",
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
      desc = "Screen First Character",
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
      desc = "Screen Last Character",
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
    },
    ["an"] = {
      "M",
      { "n", "x", "o" },
      desc = "To Middle line of window, on the first non-blank character (linewise)",
    },
    ["ac"] = {
      "gmM",
      "n",
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
      desc = "Screen First Character",
    },
    ["aal"] = {
      {
        function()
          require("reasonable-screen-move").last_character()
        end,
        { "n", "x" },
      },
      { "g$", "o" },
      desc = "Screen Last Character",
    },
  },
}
