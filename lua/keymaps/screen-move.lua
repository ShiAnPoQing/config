local function screen_col_center()
  local win_info = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local screen_width = win_info.width - win_info.textoff
  ---@diagnostic disable-next-line: undefined-field
  local leftcol = win_info.leftcol
  local screent_cursor_rol = vim.fn.virtcol(".") - leftcol
  local offset = math.ceil(screen_width / 2) - screent_cursor_rol + 1

  if offset > 0 then
    vim.api.nvim_feedkeys(offset .. "zh", "n", false)
  elseif offset < 0 then
    vim.api.nvim_feedkeys(-offset .. "zl", "n", false)
  end
end

return {
  ["H"] = {
    {
      function()
        require("builtin.screen-move").screen_left()
      end,
      "n",
    },
    { "g^", { "x", "o" } },
    desc = "Screen Left",
  },
  ["L"] = {
    {
      function()
        require("builtin.screen-move").screen_right()
      end,
      "n",
    },
    {
      "g<end>",
      { "x", "o" },
    },
    desc = "Screen Right",
  },
  ["J"] = {
    {
      function()
        require("builtin.screen-move").screen_bottom()
      end,
      { "n", "x" },
    },
    { "L", "o" },
    desc = "To line [count] from bottom of window (default: Last line on the window) on the first non-blank character",
  },
  ["K"] = {
    {
      function()
        require("builtin.screen-move").screen_top()
      end,
      { "n", "x" },
    },
    { "H", "o" },
    desc = "To line [count] from top (Home) of window (default: first line on the window) on the first non-blank character",
  },
  ["N"] = {
    "M",
    "n",
    desc = "To Middle line of window, on the first non-blank character (linewise)",
  },
  ["M"] = {
    function()
      ---@diagnostic disable-next-line: undefined-field
      local virtualedit = vim.opt_local.virtualedit:get()
      if virtualedit[1] ~= "all" then
        return "gM"
      end
      return "gm"
    end,
    "n",
    expr = true,
  },
  ["gM"] = {
    function()
      ---@diagnostic disable-next-line: undefined-field
      local virtualedit = vim.opt_local.virtualedit:get()
      if virtualedit[1] ~= "all" then
        vim.opt_local.virtualedit = "all"
        return "gm"
      else
        vim.opt_local.virtualedit = "none"
        return "gM"
      end
    end,
    "n",
    expr = true,
  },
  ["gL"] = {
    function()
      ---@diagnostic disable-next-line: undefined-field
      local virtualedit = vim.opt_local.virtualedit:get()
      if virtualedit[1] ~= "all" then
        vim.opt_local.virtualedit = "all"
      else
        vim.opt_local.virtualedit = "none"
      end
      require("builtin.screen-move").screen_right()
    end,
    "n",
  },
  ["<S-space>H"] = {
    function()
      local virt_col = vim.fn.virtcol(".")
      local line = vim.api.nvim_get_current_line()
      local display_width = vim.fn.strdisplaywidth(line)
      if virt_col <= display_width then
        return "zs"
      else
        local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
        ---@diagnostic disable-next-line: undefined-field
        local leftcol = wininfo.leftcol
        if virt_col - leftcol > 1 then
          return (virt_col - leftcol - 1) .. "zl"
        end
      end
    end,
    { "n", "x" },
    expr = true,
    desc = "Scroll the text horizontally to position the cursor at the start (left side) of the screen.",
  },
  ["<S-space>L"] = {
    function()
      local virt_col = vim.fn.virtcol(".")
      local line = vim.api.nvim_get_current_line()
      local display_width = vim.fn.strdisplaywidth(line)
      if virt_col <= display_width then
        return "ze"
      else
        local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
        local width = wininfo.width - wininfo.textoff
        ---@diagnostic disable-next-line: undefined-field
        local leftcol = wininfo.leftcol
        local win_virt_col = virt_col - leftcol
        local count = width - win_virt_col
        if count > 0 then
          return count .. "zh"
        end
      end
    end,
    { "n", "x" },
    expr = true,
    desc = "Scroll the text horizontally to position the cursor at the end (right side) of the screen.",
  },
  ["<S-space>K"] = {
    "zt",
    { "n", "x" },
    desc = "line [count] at top of window (default cursor line)(leave the cursor in the same column).",
  },
  ["<S-space>J"] = {
    "zb",
    { "n", "x" },
    desc = "line [count] at bottom of window (default cursor line)(leave the cursor in the same column).",
  },
  ["<S-space>N"] = {
    "zz",
    { "n", "x" },
    desc = "line [count] at center of window (default cursor line)(leave the cursor in the same column).",
  },
  ["<S-space>M"] = { screen_col_center, { "n" }, desc = "col at center of window" },
  -- ["ah"] = {
  --   {
  --     function()
  --       require("builtin.screen-move").move("left")
  --     end,
  --     "n",
  --     { desc = "Screen First Character" },
  --   },
  --   { "g0", { "x", "o" } },
  -- },
  -- ["al"] = {
  --   {
  --     function()
  --       require("builtin.screen-move").move("right")
  --     end,
  --     "n",
  --     { desc = "Screen Last Character" },
  --   },
  --   { "g$", { "x", "o" } },
  -- },
  -- ["<S-space><S-space>h"] = {
  --   {
  --     function()
  --       require("builtin.screen-move").move("left")
  --     end,
  --     "n",
  --     { desc = "Screen First Character" },
  --   },
  --   { "g0", { "x", "o" } },
  -- },
  -- ["<S-space><S-space>l"] = {
  --   {
  --     function()
  --       ---@diagnostic disable-next-line: undefined-field
  --       local v = vim.opt.virtualedit:get()
  --       if v[1] == "all" then
  --         vim.opt.virtualedit = "none"
  --         vim.api.nvim_feedkeys("g$", "nx", true)
  --         vim.opt.virtualedit = "all"
  --         return
  --       end
  --       vim.api.nvim_feedkeys("g$", "nx", true)
  --     end,
  --     "n",
  --     { desc = "Screen Last Character" },
  --   },
  --   { "g$", { "x", "o" } },
  -- },
  ["0J"] = {
    {
      function()
        require("custom.plugins.move.magic-move-viewport-bottom").move_viewport_bottom()
      end,
      "n",
    },
  },
  ["0K"] = {
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
      require("builtin.move-col-center").move_col_center("left")
    end,
    "n",
  },
  ["<M-m>"] = {
    function()
      require("builtin.move-col-center").move_col_center("right")
    end,
    "n",
  },

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
