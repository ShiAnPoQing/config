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
  -- normal mode cursor move: screen left
  -- 支持 count
  ["ah"] = {
    {
      function()
        require("builtin.screen-move").move("left")
      end,
      "n",
    },
    { "g0", { "x", "o" } },
  },
  -- normal mode cursor move: screen right
  -- 支持 count
  ["al"] = {
    {
      function()
        require("builtin.screen-move").move("right")
      end,
      "n",
    },
    { "g$", { "x", "o" } },
  },
  -- normal mode cursor move: screen bottom
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
  ["aal"] = { "ze", { "n", "x" } },
  -- normal mode view move: cursor word position at screen left
  ["aah"] = { "zs", { "n", "x" } },
  -- normal mode view move: cursor line position at screen top col
  ["aak"] = { "zt", { "n", "x" } },
  -- normal mode view move: cursor line position at screen bottom col
  ["aaj"] = { "zb", { "n", "x" } },
  -- normal mode view move: cursor line position at screen center col
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
