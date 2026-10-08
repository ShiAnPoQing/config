return {
  name = "reasonable-scroll.nvim",
  key = {
    ["<C-k>"] = {
      {
        function()
          my.scroll.scroll_down()
        end,
        { "n", "x" },
      },
      {
        function()
          require("reasonable-scroll").i_scroll_down()
        end,
        "i",
      },
      desc = "Scroll [count] line down(cursor follow)",
    },
    ["<C-j>"] = {
      {
        function()
          my.scroll.scroll_up()
        end,
        { "n", "x" },
      },
      {
        function()
          require("reasonable-scroll").i_scroll_up()
        end,
        "i",
      },
      desc = "Scroll [count] line up(cursor follow)",
    },
    ["<C-l>"] = {
      {
        function()
          my.scroll.scroll_right()
        end,
        { "n", "x" },
      },
      {
        function()
          require("reasonable-scroll").i_scroll_right()
        end,
        "i",
      },
      desc = "Scroll [count] col right(cursor follow)",
    },
    ["<C-h>"] = {
      {
        function()
          my.scroll.scroll_left()
        end,
        { "n", "x" },
      },
      {
        function()
          require("reasonable-scroll").i_scroll_left()
        end,
        "i",
      },
      desc = "Scroll [count] col left(cursor follow)",
    },
    ["<space><C-h>"] = {
      function()
        require("reasonable-scroll").toggle_scroll_left()
      end,
      { "n", "x" },
      desc = "Scroll [count] col left(toggle cursor follow)",
    },
    ["<space><C-j>"] = {
      function()
        require("reasonable-scroll").toggle_scroll_up()
      end,
      { "n", "x" },
      desc = "Scroll [count] line up(toggle cursor follow)",
    },
    ["<space><C-k>"] = {
      function()
        require("reasonable-scroll").toggle_scroll_down()
      end,
      { "n", "x" },
      desc = "Scroll [count] line down(toggle cursor follow)",
    },
    ["<space><C-l>"] = {
      function()
        require("reasonable-scroll").toggle_scroll_right()
      end,
      { "n", "x" },
      desc = "Scroll [count] col right(toggle cursor follow)",
    },
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
          local old = vim.o.virtualedit
          vim.o.virtualedit = "all"
          require("reasonable-scroll").scroll_half_page_right()
          local line = vim.api.nvim_get_current_line()
          local virtcol = vim.fn.virtcol(".")
          if virtcol >= #line then
            vim.api.nvim_create_autocmd("CursorMoved", {
              callback = function()
                local line = vim.api.nvim_get_current_line()
                local virtcol = vim.fn.virtcol(".")
                if virtcol <= #line then
                  vim.o.virtualedit = old
                  return true
                end
              end,
            })
          end
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
    ["<C-Space><C-k>"] = {
      function()
        require("reasonable-scroll").scroll_viewport_top()
      end,
      { "n", "x" },
      desc = "Place the line at the top of the window, offset by [count] lines",
    },
    ["<C-Space>k"] = {
      function()
        require("reasonable-scroll").scroll_viewport_top()
      end,
      { "n", "x" },
      desc = "Place the line at the top of the window, offset by [count] lines",
    },
    ["<C-Space><C-j>"] = {
      function()
        require("reasonable-scroll").scroll_viewport_bottom()
      end,
      { "n", "x" },
      desc = "Place the line at the bottom of the window, offset by [count] lines",
    },
    ["<C-Space>j"] = {
      function()
        require("reasonable-scroll").scroll_viewport_bottom()
      end,
      { "n", "x" },
      desc = "Place the line at the bottom of the window, offset by [count] lines",
    },
    ["<C-Space><C-l>"] = {
      function()
        require("reasonable-scroll").scroll_viewport_right()
      end,
      { "n", "x" },
      desc = "Place the col at the right of the window, offset by [count] cols",
    },
    ["<C-Space>l"] = {
      function()
        require("reasonable-scroll").scroll_viewport_right()
      end,
      { "n", "x" },
      desc = "Place the col at the right of the window, offset by [count] cols",
    },
    ["<C-Space><C-h>"] = {
      function()
        require("reasonable-scroll").scroll_viewport_left()
      end,
      { "n", "x" },
      desc = "Place the col at the left of the window, offset by [count] cols",
    },
    ["<C-Space>h"] = {
      function()
        require("reasonable-scroll").scroll_viewport_left()
      end,
      { "n", "x" },
      desc = "Place the col at the left of the window, offset by [count] cols",
    },
    ["<C-Space><C-n>"] = {
      "zz",
      { "n", "x" },
      desc = "Place the line at the center of the window, offset by [count] lines",
    },
    ["<C-Space>n"] = {
      "zz",
      { "n", "x" },
      desc = "Place the line at the center of the window, offset by [count] lines",
    },
    ["<S-ScrollWheelDown>"] = {
      { "zs", { "n", "x" } },
      { "<C-o>zs", "i" },
    },
    ["<S-ScrollWheelUp>"] = {
      { "ze", { "n", "x" } },
      { "<C-o>ze", "i" },
    },
    ["<C-Space><C-m>"] = {
      function()
        require("reasonable-scroll").scroll_viewport_vertical_center()
      end,
      { "n", "x" },
      desc = "Place the col at the center of the window, offset by [count] cols",
    },
    ["<C-Space>m"] = {
      function()
        require("reasonable-scroll").scroll_viewport_vertical_center()
      end,
      { "n", "x" },
      desc = "Place the col at the center of the window, offset by [count] cols",
    },
    ["zm"] = {
      function()
        require("reasonable-scroll").scroll_viewport_vertical_center()
      end,
      { "n", "x" },
      desc = "Place the col at the center of the window, offset by [count] cols",
    },
    ["zh"] = {
      function()
        require("reasonable-scroll").scroll_viewport_left()
      end,
      { "n", "x" },
      desc = "Place the col at the left of the window, offset by [count] cols",
    },
    ["zj"] = {
      function()
        require("reasonable-scroll").scroll_viewport_bottom()
      end,
      { "n", "x" },
      desc = "Place the line at the bottom of the window, offset by [count] lines",
    },
    ["zk"] = {
      function()
        require("reasonable-scroll").scroll_viewport_top()
      end,
      { "n", "x" },
      desc = "Place the line at the top of the window, offset by [count] lines",
    },
    ["zl"] = {
      function()
        require("reasonable-scroll").scroll_viewport_right()
      end,
      { "n", "x" },
      desc = "Place the col at the right of the window, offset by [count] cols",
    },
    ["zn"] = {
      "zz",
      { "n", "x" },
      desc = "line [count] at center of window (default cursor line)(leave the cursor in the same column).",
    },
  },
}
