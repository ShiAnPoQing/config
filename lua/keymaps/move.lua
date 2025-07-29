local function space_h_omode()
  vim.api.nvim_exec2(
    string.format(
      [[exec "normal! v^"]] -- 注意转义 <Up>
    ),
    {}
  )
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

local function space_k_Omode()
  local count = vim.v.count1
  vim.api.nvim_exec2(
    string.format(
      [[exec "normal! v%d\<Up>g_"]], -- 注意转义 <Up>
      count
    ),
    {}
  )
end

local function space_j_Omode()
  local count = vim.v.count1
  vim.api.nvim_exec2(
    string.format(
      [[exec "normal! v%d\<Down>g_"]], -- 注意转义 <Up>
      count
    ),
    {}
  )
end

local function aam()
  local win_info = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  local screen_width = win_info.width - win_info.textoff
  local screent_cursor_rol = vim.fn.virtcol(".") - win_info.leftcol
  local offset = math.ceil(screen_width / 2) - screent_cursor_rol + 1

  if offset > 0 then
    vim.api.nvim_feedkeys(offset .. "zh", "n", false)
  elseif offset < 0 then
    vim.api.nvim_feedkeys(-offset .. "zl", "n", false)
  end
end

local function getCount(count)
  if count == 0 then
    count = count + 1
  end

  return count
end

local function cursorLeftMove(count, multiple)
  count = getCount(count)
  vim.api.nvim_feedkeys(count * multiple .. "h", "nt", true)
end

local function cursorRightMove(count, multiple)
  count = getCount(count)
  vim.api.nvim_feedkeys(count * multiple .. "l", "nt", true)
end

local function cursorUpMove(count, multiple)
  count = getCount(count)
  vim.api.nvim_feedkeys(count * multiple .. "gk", "nt", true)
end

local function cursorDownMove(count, multiple)
  count = getCount(count)
  vim.api.nvim_feedkeys(count * multiple .. "gj", "nt", true)
end

return {
  ["h"] = {
    function()
      local count = vim.v.count
      cursorLeftMove(count, 1)
      require("repeat").Record(function()
        cursorLeftMove(count, 1)
      end)
    end,
    "n",
    { desc = "left move" },
  },
  -- ["j"] = { "gj", "n" },
  ["j"] = {
    function()
      local count = vim.v.count
      cursorDownMove(count, 1)
      require("repeat").Record(function()
        cursorDownMove(count, 1)
      end)
    end,
    "n",
    { desc = "down move" },
  },
  -- ["k"] = { "gk", "n" },
  ["k"] = {
    function()
      local count = vim.v.count
      cursorUpMove(count, 1)
      require("repeat").Record(function()
        cursorUpMove(count, 1)
      end)
    end,
    "n",
    { desc = "up move" },
  },
  ["l"] = {
    function()
      local count = vim.v.count
      cursorRightMove(count, 1)
      require("repeat").Record(function()
        cursorRightMove(count, 1)
      end)
    end,
    "n",
    { desc = "right move" },
  },
  -- ["0j"] = {
  -- 	function()
  -- 		require("custom.plugins.move").magic.move_up_down("down")
  -- 	end,
  -- 	{ "n", "x" },
  -- },
  -- ["0k"] = {
  -- 	function()
  -- 		require("custom.plugins.move").magic.move_up_down("up")
  -- 	end,
  -- 	{ "n", "x" },
  -- },
  ["H"] = {
    {
      function()
        local count = vim.v.count
        cursorLeftMove(count, 3)
        require("repeat").Record(function()
          cursorLeftMove(count, 3)
        end)
      end,
      "n",
      { desc = "Left move" },
    },
    {
      "3h",
      "x",
      { desc = "Left move" },
    },
  },
  ["J"] = {
    {
      function()
        local count = vim.v.count
        cursorDownMove(count, 3)
        require("repeat").Record(function()
          cursorDownMove(count, 3)
        end)
      end,
      "n",
      { desc = "Down move" },
    },
    {
      "3j",
      "x",
      { desc = "Down move" },
    },
  },
  ["K"] = {
    {
      function()
        local count = vim.v.count
        cursorUpMove(count, 3)
        require("repeat").Record(function()
          cursorUpMove(count, 3)
        end)
      end,
      "n",
      { desc = "Up move" },
    },
    {
      "3k",
      "x",
      { desc = "Up move" },
    },
  },
  ["L"] = {
    {
      function()
        local count = vim.v.count
        cursorRightMove(count, 3)
        require("repeat").Record(function()
          cursorRightMove(count, 3)
        end)
      end,
      "n",
      { desc = "Right move" },
    },
    {
      "3l",
      "x",
      { desc = "Right move" },
    },
  },
  -- ["H"] = { "3h", { "n", "x" } },
  -- ["J"] = { "3j", { "n", "x" } },
  -- ["K"] = { "3k", { "n", "x" } },
  -- ["L"] = { "3l", { "n", "x" } },

  -- 支持 count 可以向上
  ["<space>h"] = {
    {
      function()
        require("custom.plugins.move").move_start_end("left")
      end,
      "n",
    },
    { "^", "x" },
    { space_h_omode, "o" },
  },
  -- ["0<space>h"] = {
  -- 	function()
  -- 		require("custom.plugins.move").magic.move_start_end("left")
  -- 	end,
  -- 	"n",
  -- },
  ["0<space>l"] = {
    function()
      require("custom.plugins.move").magic.move_start_end("right")
    end,
    "n",
  },
  ["<space><M-h>"] = {
    "I",
    "n",
  },
  ["<space>D"] = {
    "xd^",
    "n",
    { noremap = true },
  },
  -- 支持 count 可以向下
  ["<space>l"] = {
    {
      function()
        require("custom.plugins.move").move_start_end("right")
      end,
      "n",
    },
    { "g_", { "x", "o" } },
  },
  ["<space><M-l>"] = {
    "A",
    "n",
  },
  ["<space>j"] = {
    { space_j_Omode, "o" },
    { "<Down>g_", { "n", "x" } },
  },
  ["<space>k"] = {
    { space_k_Omode, "o", { noremap = true } },
    { "<Up>g_", { "n", "x" } },
  },

  -- 支持百分比 count
  ["<space>m"] = { "gM", { "n", "x", "o" } },
  -- 支持百分比 count
  ["<space>n"] = { "gM", { "n", "x", "o" } },
  ["<M-space><M-m>"] = { "<C-o>gM", { "i" } },
  ["<M-space><M-n>"] = { "<C-o>gM", { "i" } },

  -- 支持 count 向上
  ["<space><space>h"] = {
    { space_space_h, "n" },
    { "0", { "x", "o" } },
  },
  -- 支持 count 向下
  ["<space><space>l"] = { "$", { "n", "x", "o" } },

  -- 缺少： up down to first 空白字符
  ["<space><space>j"] = { "+", { "n", "x", "o" } },
  ["<space><space>k"] = { "-", { "n", "x", "o" } },

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
  -- ["<space>am"] = {
  --   function()
  --     local count = vim.v.count1
  --     require("base-function").JumpToMiddle(count, "left")
  --     require("repeat").Record(function()
  --       require("base-function").JumpToMiddle(count, "left")
  --     end)
  --   end,
  --   "n",
  -- },
  -- -- jump the middle of cursor to right
  -- ["<space><space>am"] = {
  --   function()
  --     local count = vim.v.count1
  --     require("base-function").JumpToMiddle(count, "right")
  --     require("repeat").Record(function()
  --       require("base-function").JumpToMiddle(count, "right")
  --     end)
  --   end,
  --   "n",
  -- },
  -- -- jump the middle of cursor to top
  -- ["<space>an"] = {
  --   function()
  --     local count = vim.v.count1
  --     require("base-function").JumpToMiddle(count, "up")
  --     require("repeat").Record(function()
  --       require("base-function").JumpToMiddle(count, "up")
  --     end)
  --   end,
  --   "n",
  -- },
  -- -- jump the middle of cursor to bottom
  -- ["<space><space>an"] = {
  --   function()
  --     local count = vim.v.count1
  --     require("base-function").JumpToMiddle(count, "down")
  --     require("repeat").Record(function()
  --       require("base-function").JumpToMiddle(count, "down")
  --     end)
  --   end,
  --   "n",
  -- },

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
  ["aam"] = {
    function()
      aam()
    end,
    { "n" },
  },

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

  ["{"] = { "{zz", "n" },
  ["}"] = { "}zz", "n" },

  ["<space>G"] = { "<C-End>", { "n", "x", "o" } },
  ["<space><space>G"] = { "G0", { "n", "x", "o" } },
  ["<space>gg"] = { "gg<End>", { "n", "x", "o" } },
  ["<space><space>gg"] = { "gg0", { "n", "x", "o" } },
  -- insert mode move: k,
  ["<M-k>"] = {
    { "<Up>", { "i", "c", "s" }, { silent = false } },
    { "<C-W>k^", { "n" } },
    -- {""},
    { "<up>", "t" },
  },
  -- ["<M-C-k>"] = {
  --   "<C-W>k^",
  --   "n"
  -- },
  -- insert mode move: j,
  ["<M-j>"] = {
    { "<Down>", { "i", "c", "s" }, { silent = false } },
    -- { "<C-W>j^", { "n" } },
    { "<down>", "t" },
  },
  -- ["<M-C-j>"] = {
  --   "<C-W>j^",
  --   "n"
  -- },
  -- insert mode move: h,
  ["<M-h>"] = {
    { "<left>", { "i", "c", "s" }, { silent = false } },
    -- { "<C-W>h^", { "n" } },
    -- { "i",      "n" },
    { "<left>", "t" },
  },
  -- ["<M-C-h>"] = {
  --   "<C-W>h^",
  --   "n"
  -- },
  -- insert mode move: l,
  ["<M-l>"] = {
    { "<right>", { "i", "c", "s" }, { silent = false } },
    --  { "a",       "n" },
    -- { "<C-W>l^", { "n" } },
    { "<right>", "t" },
  },
  -- ["<M-C-l>"] = {
  --   "<C-W>l^",
  --   "n"
  -- },
  -- insert mode move: exclusive words like e,
  ["<M-space><M-i>"] = {
    { "<Esc>gea", { "i" } },
  },
  -- insert mode move: exclusive words like E,
  ["<M-space><M-S-i>"] = {
    { "<Esc>gEa", { "i" } },
  },
  -- insert mode move: exclusive words like w,
  ["<M-space><M-o>"] = {
    { "<S-right>", { "i" } },
  },
  -- insert mode move: exclusive words like W,
  ["<M-space><M-S-o>"] = {
    { "<Esc>Wi", { "i" } },
  },
  -- insert mode move: like H,
  ["<M-S-h>"] = {
    { "<C-o>3h", { "i" }, { silent = false } },
    { "<left><left><left><left><left>", "t" },
  },
  -- insert mode move: like J,
  ["<M-S-j>"] = {
    { "<C-o>3j", { "i" }, { silent = false } },
    { "<down><down><down><down><down>", "t" },
  },

  -- insert mode move: like K,
  ["<M-S-k>"] = {
    { "<C-o>3k", { "i" }, { silent = false } },
    { "<up><up><up><up><up>", "t" },
  },
  -- insert mode move: like L,
  ["<M-S-l>"] = {
    { "<C-o>3l", { "i" }, { silent = false } },
    { "<right><right><right><right><right>", "t" },
  },
  -- insert mode move: screen left,
  ["<M-1><M-h>"] = { "<C-o>g0", { "i" } },
  ["<M-space>h"] = { "<C-o>g0", "i" },
  -- insert mode move: screen right,
  ["<M-1><M-l>"] = { "<C-o>g$", { "i" } },
  ["<M-space>l"] = { "<C-o>g$", "i" },
  -- insert mode move: screen bottom,
  ["<M-1><M-j>"] = { "<C-o>L", { "i" } },
  ["<M-space>j"] = { "<C-o>L", "i" },
  -- insert mode move: screen top,
  ["<M-1><M-k>"] = { "<C-o>H", { "i" } },
  ["<M-space>k"] = { "<C-o>H", "i" },
  -- insert mode move: screen center,
  ["<M-1><M-m>"] = { "<C-o>gm", { "i" } },
  ["<M-space>m"] = { "<C-o>gm", "i" },
  -- insert mode move: screen center col,
  ["<M-1><M-n>"] = { "<C-o>M", { "i" } },
  ["<M-space>n"] = { "<C-o>M", "i" },
  -- insert mode move: Home(ignore space),
  ["<M-space><M-h>"] = {
    { "<C-o>I", "i" },
    { "<C-G>^<C-G>", "s" },
    { "I", "n" },
    { "<Home>", "t" },
    -- { "<C-W>H", "n" },
  },
  -- insert mode move: Home,
  ["<M-space><M-space><M-h>"] = { "<Home>", { "i", "c" }, { silent = false } },
  -- insert mode move: End,
  ["<M-space><M-l>"] = {
    { "<C-o>A", "i" },
    { "<C-G>g_<C-G>", "s" },
    { "A", "n" },
    { "<End>", "t" },
    -- { "<C-W>L", "n" },
  },
  -- insert mode move: End,
  ["<M-space><M-space><M-l>"] = { "<End>", { "i", "c" }, { silent = false } },
  -- insert mode move: Up End,
  ["<M-space><M-k>"] = {
    { "<Up><End>", { "i" } },
    { "<C-W>K", "n" },
  },
  -- insert mode move: Up Home,
  ["<M-space><M-space><M-k>"] = { "<Up><Home>", { "i" } },
  -- insert mode move: Down End
  ["<M-space><M-j>"] = {
    { "<Down><End>", { "i" } },
    { "<C-W>J", "n" },
  },
  -- insert mode move: Down Home,
  ["<M-space><M-space><M-j>"] = { "<Down><Home>", { "i" } },

  ["0m"] = {
    function()
      require("custom.plugins.move.magic-move").move()
    end,
    "n",
  },
}
