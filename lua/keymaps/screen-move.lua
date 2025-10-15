local function aam()
  local win_info = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local screen_width = win_info.width - win_info.textoff
  local screent_cursor_rol = vim.fn.virtcol(".") - win_info.leftcol
  local offset = math.ceil(screen_width / 2) - screent_cursor_rol

  if offset > 0 then
    vim.api.nvim_feedkeys(offset .. "zh", "n", false)
  elseif offset < 0 then
    vim.api.nvim_feedkeys(-offset .. "zl", "n", false)
  end
end

return {
  ["<S-space>h"] = {
    function()
      local before_cursor = vim.api.nvim_win_get_cursor(0)
      vim.api.nvim_feedkeys("g^", "nx", true)
      local after_cursor = vim.api.nvim_win_get_cursor(0)

      if before_cursor[2] == after_cursor[2] then
        vim.api.nvim_feedkeys("g0", "nx", true)
      end
    end,
    { "n", "x", "o" },
    desc = "Screen First Non-blank Character",
  },
  ["<S-space>l"] = {
    {
      function()
        if vim.opt.virtualedit:get()[1] == "all" then
          vim.opt.virtualedit = "none"
          vim.api.nvim_feedkeys("g" .. vim.api.nvim_replace_termcodes("<end>", true, false, true), "nx", true)
          vim.opt.virtualedit = "all"
          return
        end
        vim.api.nvim_feedkeys("g" .. vim.api.nvim_replace_termcodes("<end>", true, false, true), "nx", true)
      end,
      { "n", "x" },
    },
    {
      function()
        if vim.opt.virtualedit:get()[1] == "all" then
          vim.opt.virtualedit = "none"
          vim.api.nvim_feedkeys("vg" .. vim.api.nvim_replace_termcodes("<end>", true, false, true), "nx", true)
          vim.opt.virtualedit = "all"
          return
        end
        vim.api.nvim_feedkeys("vg" .. vim.api.nvim_replace_termcodes("<end>", true, false, true) .. "h", "nx", true)
      end,
      "o",
    },
    desc = "Screen Last Non-blank Character",
  },
  ["ah"] = {
    {
      function()
        require("builtin.screen-move").move("left")
      end,
      "n",
      { desc = "Screen First Character" },
    },
    { "g0", { "x", "o" } },
  },
  ["al"] = {
    {
      function()
        require("builtin.screen-move").move("right")
      end,
      "n",
      { desc = "Screen Last Character" },
    },
    { "g$", { "x", "o" } },
  },
  ["<S-space><S-space>h"] = {
    {
      function()
        require("builtin.screen-move").move("left")
      end,
      "n",
      { desc = "Screen First Character" },
    },
    { "g0", { "x", "o" } },
  },
  ["<S-space><S-space>l"] = {
    {
      function()
        if vim.opt.virtualedit:get()[1] == "all" then
          vim.opt.virtualedit = "none"
          vim.api.nvim_feedkeys("g$", "nx", true)
          vim.opt.virtualedit = "all"
          return
        end
        vim.api.nvim_feedkeys("g$", "nx", true)
      end,
      "n",
      { desc = "Screen Last Character" },
    },
    { "g$", { "x", "o" } },
  },
  ["aj"] = {
    {
      function()
        require("builtin.screen-move").move("bottom")
      end,
      "n",
    },
    { "L", { "x", "o" } },
  },
  ["0aj"] = {
    {
      function()
        require("custom.plugins.move.magic-move-viewport-bottom").move_viewport_bottom()
      end,
      "n",
    },
  },
  -- normal mode cursor move: screen top
  ["ak"] = {
    {
      function()
        require("builtin.screen-move").move("top")
      end,
      "n",
    },
    { "H", { "x", "o" } },
  },
  ["0ak"] = {
    {
      function()
        require("custom.plugins.move.magic-move-viewport-top").move_viewport_top()
      end,
      "n",
    },
  },
  -- normal mode cursor move: screen center
  ["am"] = {
    {
      function()
        require("builtin.screen-move").move("h_center")
      end,
      "n",
    },
    { "gm", { "x", "o" } },
  },
  ["0am"] = {
    {
      function()
        require("custom.plugins.move.magic-move-viewport-horizontal-center").move_horizontal_center()
      end,
      "n",
    },
  },
  -- normal mode cursor move: screen center col
  ["an"] = {
    {
      function()
        require("builtin.screen-move").move("v_center")
      end,
      "n",
    },
    { "M", { "x", "o" } },
  },
  ["0an"] = {
    function()
      require("custom.plugins.move.magic-move-viewport-vertical-center").move_vertical_center()
    end,
    "n",
  },
  ["ac"] = {
    "gmM",
    "n",
  },
  -- jump the middle of cursor to left
  ["<C-m>"] = {
    function()
      require("custom.builtin.move-col-center").move_col_center("left")
    end,
    "n",
  },
  ["<M-m>"] = {
    function()
      require("custom.builtin.move-col-center").move_col_center("right")
    end,
    "n",
  },
  ["aal"] = {
    "ze",
    { "n", "x" },
    desc = "Scroll the text horizontally to position the cursor at the end (right side) of the screen.",
  },
  ["aah"] = {
    "zs",
    { "n", "x" },
    desc = "Scroll the text horizontally to position the cursor at the start (left side) of the screen.",
  },
  ["aak"] = {
    "zt",
    { "n", "x" },
    desc = "line [count] at top of window (default cursor line)(leave the cursor in the same column).",
  },
  ["aaj"] = {
    "zb",
    { "n", "x" },
    desc = "line [count] at bottom of window (default cursor line)(leave the cursor in the same column).",
  },
  ["aan"] = {
    "zz",
    { "n", "x" },
    desc = "line [count] at center of window (default cursor line)(leave the cursor in the same column).",
  },
  -- normal mode view move: cursor line position at screen center row
  ["aam"] = { aam, { "n" }, desc = "col at center of window" },

  -- normal mode view move: cursor word position at screen right
  ["<M-a><M-a><M-l>"] = {
    "<C-o>ze",
    "i",
    desc = "Scroll the text horizontally to position the cursor at the end (right side) of the screen.",
  },
  -- normal mode view move: cursor word position at screen left
  ["<M-a><M-a><M-h>"] = {
    "<C-o>zs",
    "i",
    desc = "Scroll the text horizontally to position the cursor at the start (left side) of the screen.",
  },
  -- normal mode view move: cursor line position at screen top col
  ["<M-a><M-a><M-k>"] = {
    "<C-o>zt",
    "i",
    desc = "line [count] at top of window (default cursor line)(leave the cursor in the same column).",
  },
  -- normal mode view move: cursor line position at screen bottom col
  ["<M-a><M-a><M-j>"] = {
    "<C-o>zb",
    "i",
    desc = "line [count] at bottom of window (default cursor line)(leave the cursor in the same column).",
  },
  -- normal mode view move: cursor line position at screen center col
  ["<M-a><M-a><M-n>"] = {
    "<C-o>zz",
    "i",
    desc = "line [count] at center of window (default cursor line)(leave the cursor in the same column).",
  },
}
