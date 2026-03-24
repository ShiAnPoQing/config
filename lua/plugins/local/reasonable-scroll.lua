return {
  name = "reasonable-scroll.nvim",
  key = {
    ["<C-S-k>"] = {
      {
        function()
          require("reasonable-scroll").scroll_page_up()
        end,
        { "n", "x" },
      },
      {
        function()
          require("reasonable-scroll").i_scroll_page_up()
        end,
        "i",
      },
      desc = "Scroll [count] page up",
    },
    ["<C-S-j>"] = {
      {
        function()
          require("reasonable-scroll").scroll_page_down()
        end,
        { "n", "x" },
      },
      {
        function()
          require("reasonable-scroll").i_scroll_page_down()
        end,
        "i",
      },
      desc = "Scroll [count] page down",
    },
    ["<C-S-h>"] = {
      {
        function()
          require("reasonable-scroll").scroll_half_page_left()
        end,
        { "n", "x" },
      },
      {
        function()
          require("reasonable-scroll").i_scroll_half_page_left()
        end,
        "i",
      },
      desc = "Scroll [count] half page left",
    },
    ["<C-S-l>"] = {
      {
        function()
          require("reasonable-scroll").scroll_half_page_right()
        end,
        { "n", "x" },
      },
      {
        function()
          require("reasonable-scroll").i_scroll_half_page_right()
        end,
        "i",
        desc = "Scroll [count] half page right",
      },
    },
  },
}
