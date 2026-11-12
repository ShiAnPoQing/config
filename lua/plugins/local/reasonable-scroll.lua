return {
  name = "reasonable-scroll.nvim",
  key = {
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
    ["sm"] = {
      function()
        require("reasonable-scroll").scroll_viewport_vertical_center()
      end,
      { "n", "x" },
      desc = "Place the col at the center of the window, offset by [count] cols",
    },
    ["sh"] = {
      function()
        require("reasonable-scroll").scroll_viewport_left()
      end,
      { "n", "x" },
      desc = "Place the col at the left of the window, offset by [count] cols",
    },
    ["sj"] = {
      function()
        require("reasonable-scroll").scroll_viewport_bottom()
      end,
      { "n", "x" },
      desc = "Place the line at the bottom of the window, offset by [count] lines",
    },
    ["sk"] = {
      function()
        require("reasonable-scroll").scroll_viewport_top()
      end,
      { "n", "x" },
      desc = "Place the line at the top of the window, offset by [count] lines",
    },
    ["sl"] = {
      function()
        require("reasonable-scroll").scroll_viewport_right()
      end,
      { "n", "x" },
      desc = "Place the col at the right of the window, offset by [count] cols",
    },
    ["sn"] = {
      "zz",
      { "n", "x" },
      desc = "line [count] at center of window (default cursor line)(leave the cursor in the same column).",
    },
  },
}
