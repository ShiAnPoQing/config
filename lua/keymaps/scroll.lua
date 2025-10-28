return {
  ["<space><C-j>"] = {
    function()
      require("builtin.scroll").toggle_cursor_follow("down")
    end,
    "n",
  },
  ["<space><C-k>"] = {
    function()
      require("builtin.scroll").toggle_cursor_follow("up")
    end,
    "n",
  },
  ["<space><C-l>"] = {
    function()
      require("builtin.scroll").toggle_cursor_follow("right")
    end,
    "n",
  },
  ["<space><C-h>"] = {
    function()
      require("builtin.scroll").toggle_cursor_follow("left")
    end,
    "n",
  },
  ["<C-j>"] = {
    {
      function()
        require("builtin.scroll").scroll_down()
      end,
      "n",
    },
    { "<C-y>", "x" },
    { "<C-o><C-y>", "i" },
    desc = "Scroll window [count] lines upwards in the buffer",
  },
  ["<C-k>"] = {
    {
      function()
        require("builtin.scroll").scroll_up()
      end,
      "n",
    },
    { "<C-e>", "x" },
    { "<C-o><C-e>", "i" },
    desc = "Scroll window [count] lines downwards in the buffer.",
  },
  ["<C-h>"] = {
    {
      function()
        require("builtin.scroll").scroll_left()
      end,
      "n",
    },
    { "2zl", "x" },
    { "<C-o>2zl", "i" },
    desc = "Move the view on the text [count] characters to the right",
  },
  ["<C-l>"] = {
    {
      function()
        require("builtin.scroll").scroll_right()
      end,
      "n",
    },
    { "2zh", "x" },
    { "<C-o>2zh", "i" },
    desc = "Move the view on the text [count] characters to the left",
  },
  ["<C-S-j>"] = {
    {
      function()
        require("builtin.scroll").scroll_backward_one_page()
      end,
      "n",
    },
    {
      function()
        vim.cmd.stopinsert()
        require("builtin.scroll").scroll_backward_one_page()
        vim.cmd.startinsert()
      end,
      "i",
    },
    { "<C-f>", "x" },
    desc = "Scroll window [count] pages Forwards (downwards) in the buffer.",
  },
  ["<C-S-k>"] = {
    {
      function()
        require("builtin.scroll").scroll_forward_one_page()
      end,
      "n",
    },
    {
      function()
        vim.cmd.stopinsert()
        require("builtin.scroll").scroll_forward_one_page()
        vim.cmd.startinsert()
      end,
      "i",
    },
    { "<C-b>", "x" },
    desc = "Scroll window [count] pages Backwards (upwards) in the buffer.",
  },
  ["<C-S-l>"] = {
    {
      function()
        return require("builtin.scroll").scroll_half_screen_right()
      end,
      { "n", "x" },
      expr = true,
    },
    {
      function()
        require("builtin.scroll").scroll_half_screen_right_i_mode()
      end,
      "i",
    },
    desc = "Move the view on the text half a screenwidth to the right",
  },
  ["<C-S-h>"] = {
    {
      function()
        return require("builtin.scroll").scroll_half_screen_left()
      end,
      { "n", "x" },
      expr = true,
    },
    {
      function()
        require("builtin.scroll").scroll_half_screen_left_i_mode()
      end,
      "i",
    },
    desc = "Move the view on the text half a screenwidth to the left",
  },
  ["<C-Space><C-j>"] = {
    function()
      local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]()
      local botline = wininfo.botline
      local line = vim.fn.line(".")
      if botline == line then
        return "<C-b>zb"
      else
        return "zb"
      end
    end,
    "n",
    expr = true,
    desc = "line [count] at bottom of window (default cursor line)(leave the cursor in the same column.)",
  },
  ["<C-Space><C-k>"] = {
    function()
      local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]()
      local topline = wininfo.topline
      local line = vim.fn.line(".")
      if topline == line then
        return "<C-f>zt"
      else
        return "zt"
      end
    end,
    "n",
    expr = true,
    desc = "line [count] at top of window (default cursor line)(leave the cursor in the same column.)",
  },
  ["<C-Space><C-l>"] = {
    "<S-Space>L",
    "n",
    remap = true,
    desc = "Scroll the text horizontally to position the cursor at the end (right side) of the screen.",
  },
  ["<C-Space><C-h>"] = {
    "<S-space>H",
    "n",
    remap = true,
    desc = "Scroll the text horizontally to position the cursor at the start (left side) of the screen.",
  },
  ["<C-Space><C-n>"] = {
    "zz",
    "n",
    desc = "line [count] at center of window (default cursor line)(leave the cursor in the same column)",
  },
  ["<C-Space><C-m>"] = {
    "<S-space>M",
    "n",
    remap = true,
    desc = "col at center of window (default cursor col)(leave the cursor in the same row)",
  },
  ["<S-ScrollWheelDown>"] = {
    { "zs", "n" },
    { "<C-o>zs", "i" },
  },
  ["<S-ScrollWheelUp>"] = {
    { "ze", "n" },
    { "<C-o>ze", "i" },
  },
}
