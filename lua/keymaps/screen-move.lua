local function screen_col_center() end

return {
  -- ["gM"] = {
  --   function()
  --     ---@diagnostic disable-next-line: undefined-field
  --     local virtualedit = vim.opt_local.virtualedit:get()
  --     if virtualedit[1] ~= "all" then
  --       vim.opt_local.virtualedit = "all"
  --       return "gm"
  --     else
  --       vim.opt_local.virtualedit = "none"
  --       return "gM"
  --     end
  --   end,
  --   "n",
  --   expr = true,
  -- },
  -- ["gL"] = {
  --   function()
  --     ---@diagnostic disable-next-line: undefined-field
  --     local virtualedit = vim.opt_local.virtualedit:get()
  --     if virtualedit[1] ~= "all" then
  --       vim.opt_local.virtualedit = "all"
  --     else
  --       vim.opt_local.virtualedit = "none"
  --     end
  --     require("builtin.screen-move").screen_right()
  --   end,
  --   "n",
  -- },
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
  -- ["0J"] = {
  --   {
  --     function()
  --       require("custom.plugins.move.magic-move-viewport-bottom").move_viewport_bottom()
  --     end,
  --     "n",
  --   },
  -- },
  -- ["0K"] = {
  --   {
  --     function()
  --       require("custom.plugins.move.magic-move-viewport-top").move_viewport_top()
  --     end,
  --     "n",
  --   },
  -- },
  -- normal mode cursor move: screen center
  -- ["am"] = {
  --   {
  --     function()
  --       require("builtin.screen-move").move("h_center")
  --     end,
  --     "n",
  --   },
  --   { "gm", { "x", "o" } },
  -- },
  -- ["0am"] = {
  --   {
  --     function()
  --       require("custom.plugins.move.magic-move-viewport-horizontal-center").move_horizontal_center()
  --     end,
  --     "n",
  --   },
  -- },
  -- normal mode cursor move: screen center col
  -- ["an"] = {
  --   {
  --     function()
  --       require("builtin.screen-move").move("v_center")
  --     end,
  --     "n",
  --   },
  --   { "M", { "x", "o" } },
  -- },
  -- ["0an"] = {
  --   function()
  --     require("custom.plugins.move.magic-move-viewport-vertical-center").move_vertical_center()
  --   end,
  --   "n",
  -- },
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
