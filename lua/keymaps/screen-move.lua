--- @return boolean
local function on_screen_col_border(key)
  local before_col = vim.fn.virtcol(".")
  vim.api.nvim_feedkeys(key, "nx", false)
  local after_col = vim.fn.virtcol(".")
  return before_col == after_col
end

local function on_screen_row_border(key)
  local before_row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_feedkeys(key, "nx", false)
  local after_row = vim.api.nvim_win_get_cursor(0)[1]
  return before_row == after_row
end

-- g0 默认不支持 count
local function a_h()
  local count = vim.v.count1
  for i = 1, count do
    if on_screen_col_border("g0") then
      vim.api.nvim_feedkeys("zeg0", "nx", false)
      if vim.api.nvim_win_get_cursor(0)[2] == 0 then
        break
      end
    else
      if count > 1 then
        vim.api.nvim_feedkeys(count - 1 .. "k", "nx", false)
      end
    end
  end
end

local function a_l()
  local count = vim.v.count1
  for i = 1, count do
    if on_screen_col_border("g$") then
      vim.api.nvim_feedkeys("zsg$", "nx", false)
    else
      vim.api.nvim_feedkeys(count .. "g$", "nx", false)
    end
  end
end

local function a_j()
  local count = vim.v.count1
  for i = 1, count do
    if on_screen_row_border("L") then
      vim.api.nvim_feedkeys("ztL", "nx", false)
    else
      vim.api.nvim_feedkeys(count .. "L", "nx", false)
    end
  end
end

local function a_k()
  local count = vim.v.count1
  for i = 1, count do
    if on_screen_row_border("H") then
      vim.api.nvim_feedkeys("zbH", "nx", false)
      if vim.api.nvim_win_get_cursor(0)[1] == 1 then
        break
      end
    else
      vim.api.nvim_feedkeys(count .. "H", "nx", false)
    end
  end
end

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
    { a_h, "n" },
    { "g0", { "x", "o" } },
  },
  ["0ah"] = {
    {
      function()
        require("custom.plugins.move.magic-move-viewport-left").move_viewport_left()
      end,
      "n",
    },
  },
  -- normal mode cursor move: screen right
  -- 支持 count
  ["al"] = {
    { a_l, "n" },
    { "g$", { "x", "o" } },
  },
  ["0al"] = {
    {
      function()
        require("custom.plugins.move.magic-move-viewport-right").move_viewport_right()
      end,
      "n",
    },
  },
  -- normal mode cursor move: screen bottom
  ["aj"] = {
    { a_j, "n" },
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
    { a_k, "n" },
    {
      function()
        require("custom.plugins.move.move-viewport-top").move_viewport_top()
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
    { "gm", { "x", "o", "n" } },
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
        require("custom.plugins.move.move-viewport-vertical-center").move_vertical_center()
      end,
      "n",
    },
    { "M", { "x", "o" } },
  },
  ["1an"] = {
    {
      function()
        require("custom.plugins.move.move-viewport-vertical-center").move_vertical_center({ one_count = true })
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
  -- jump the middle of cursor to left
  ["<C-m>"] = {
    function()
      require("custom.plugins.move-col-center").move_col_center("left")
    end,
    "n",
  },
  ["<M-m>"] = {
    function()
      require("custom.plugins.move-col-center").move_col_center("right")
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
