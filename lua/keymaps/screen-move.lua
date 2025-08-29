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

local function space_h_omode()
  vim.api.nvim_exec2(string.format([[exec "normal! v^"]]), {})
end

-- 0 默认不支持 count
local function space_space_h()
  local count = vim.v.count1
  if count == 1 then
    vim.api.nvim_feedkeys("0", "n", false)
  else
    vim.api.nvim_feedkeys(count - 1 .. "k0", "n", false)
  end
end

return {
  ["<space>H"] = {
    {
      function()
        require("custom.plugins.move").move_start_end("left")
      end,
      "n",
    },
    { "^", "x" },
    { space_h_omode, "o" },
  },
  ["<space>L"] = {
    {
      function()
        require("custom.plugins.move").move_start_end("right")
      end,
      "n",
    },
    { "g_", { "x", "o" } },
  },
  ["<space>K"] = {
    "gg",
    { "n", "x", "o" },
  },
  ["<space>J"] = {
    "G",
    { "n", "x", "o" },
  },
  ["<space><space>H"] = {
    { space_space_h, "n" },
    { "0", { "x", "o" } },
  },
  ["<space><space>L"] = { "$", { "n", "x", "o" } },
  ["<space><space>K"] = { "gg", { "n", "x", "o" } },
  ["<space><space>J"] = { "G", { "n", "x", "o" } },

  ["<space>h"] = {
    function()
      local before_cursor = vim.api.nvim_win_get_cursor(0)
      vim.api.nvim_feedkeys("g^", "nx", true)
      local after_cursor = vim.api.nvim_win_get_cursor(0)

      if before_cursor[2] == after_cursor[2] then
        vim.api.nvim_feedkeys("g0", "nx", true)
      end
    end,
    { "n", "x", "o" },
    { desc = "Screen First Non-blank Character" },
  },
  ["<space>l"] = {
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
  ["<space><space>h"] = {
    {
      function()
        require("builtin.screen-move").move("left")
      end,
      "n",
      { desc = "Screen First Character" },
    },
    { "g0", { "x", "o" } },
  },
  ["<space><space>l"] = {
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
  -- normal mode view move: cursor word position at screen right
  -- ["aal"] = { "ze", { "n", "x" } },
  -- -- normal mode view move: cursor word position at screen left
  -- ["aah"] = { "zs", { "n", "x" } },
  -- -- normal mode view move: cursor line position at screen top col
  -- ["aak"] = { "zt", { "n", "x" } },
  -- -- normal mode view move: cursor line position at screen bottom col
  -- ["aaj"] = { "zb", { "n", "x" } },
  -- normal mode view move: cursor line position at screen center col
  ["aL"] = { "ze", { "n", "x" } },
  ["aH"] = { "zs", { "n", "x" } },
  ["aK"] = { "zt", { "n", "x" } },
  ["aJ"] = { "zb", { "n", "x" } },
  ["aan"] = { "zz", { "n", "x" } },
  -- normal mode view move: cursor line position at screen center row
  ["aam"] = { aam, { "n" } },

  -- normal mode view move: cursor word position at screen right
  ["<M-1><M-1><M-l>"] = { "<C-o>zs", { "i" } },
  -- normal mode view move: cursor word position at screen left
  ["<M-1><M-1><M-h>"] = { "<C-o>ze", { "i" } },
  -- normal mode view move: cursor line position at screen top col
  ["<M-1><M-1><M-k>"] = { "<C-o>zb", { "i" } },
  -- normal mode view move: cursor line position at screen bottom col
  ["<M-1><M-1><M-j>"] = { "<C-o>zt", { "i" } },
  -- normal mode view move: cursor line position at screen center col
  ["<M-1><M-1><M-n>"] = { "<C-o>zz", { "i" } },
}
