local function space_k_Omode()
  local count = vim.v.count1
  vim.api.nvim_exec2(string.format([[exec "normal! v%d\<Up>g_"]], count), {})
end

local function space_j_Omode()
  local count = vim.v.count1
  vim.api.nvim_exec2(string.format([[exec "normal! v%d\<Down>g_"]], count), {})
end

local function large_move(key)
  vim.cmd("normal! " .. vim.v.count1 * 3 .. key)
end

local function switch_virtualedit()
  ---@diagnostic disable-next-line: undefined-field
  local virt = vim.opt_local.virtualedit:get()[1]
  if virt == "all" then
    vim.opt_local.virtualedit = "none"
  else
    vim.opt_local.virtualedit = "all"
  end
end

return {
  ["gj"] = {
    function()
      switch_virtualedit()
      return vim.v.count == 0 and "gj" or "j"
    end,
    "n",
    expr = true,
  },
  ["gk"] = {
    function()
      switch_virtualedit()
      return vim.v.count == 0 and "gk" or "k"
    end,
    "n",
    expr = true,
  },
  ["gl"] = {
    function()
      switch_virtualedit()
      return "l"
    end,
    "n",
    expr = true,
  },
  ["j"] = {
    function()
      return vim.v.count == 0 and "gj" or "j"
    end,
    "n",
    expr = true,
  },
  ["k"] = {
    function()
      return vim.v.count == 0 and "gk" or "k"
    end,
    "n",
    expr = true,
  },
  ["<down>"] = {
    function()
      return vim.v.count == 0 and "gj" or "j"
    end,
    "n",
    expr = true,
  },
  ["<up>"] = {
    function()
      return vim.v.count == 0 and "gk" or "k"
    end,
    "n",
    expr = true,
  },
  ["H"] = {
    function()
      large_move("h")
    end,
    { "x", "n" },
    desc = "3h",
  },
  ["J"] = {
    function()
      large_move(vim.v.count == 0 and "gj" or "j")
    end,
    { "x", "n" },
    desc = "3j",
  },
  ["K"] = {
    function()
      large_move(vim.v.count == 0 and "gk" or "k")
    end,
    { "x", "n" },
    desc = "3k",
  },
  ["L"] = {
    function()
      large_move("l")
    end,
    { "x", "n" },
    desc = "3l",
  },
  ["<space><M-h>"] = {
    "I",
    "n",
  },
  ["<space><M-l>"] = {
    "A",
    "n",
  },
  ["<space>D"] = {
    "xd^",
    "n",
    noremap = true,
  },
  ["<space>j"] = {
    { space_j_Omode, "o" },
    { "<Down>g_", { "n", "x" } },
  },
  ["<space>k"] = {
    { space_k_Omode, "o", noremap = true },
    { "<Up>g_", { "n", "x" } },
  },

  ["<space>m"] = { "gM", { "n", "x", "o" } },
  ["<space>n"] = { "M", { "n", "x", "o" } },
  ["<M-space><M-m>"] = { "<C-o>gM", { "i" } },
  ["<M-space><M-n>"] = { "<C-o>gM", { "i" } },

  -- 缺少： up down to first 空白字符
  ["<space><space>j"] = { "+", { "n", "x", "o" } },
  ["<space><space>k"] = { "-", { "n", "x", "o" } },

  ["{"] = { "{zz", "n" },
  ["}"] = { "}zz", "n" },

  ["<space>G"] = { "<C-End>", { "n", "x", "o" } },
  ["<space><space>G"] = { "G0", { "n", "x", "o" } },
  ["<space>gg"] = { "gg<End>", { "n", "x", "o" } },
  ["<space><space>gg"] = { "gg0", { "n", "x", "o" } },
  -- insert mode move: k,
  ["<M-k>"] = {
    { "<Up>", { "i", "c", "s" } },
    -- { "kg_", { "n" } },
    { "<up>", "t" },
  },
  -- ["<C-k>"] = {
  --   "-",
  --   "n",
  -- },
  -- ["<M-C-k>"] = {
  --   "<C-W>k^",
  --   "n"
  -- },
  -- insert mode move: j,
  ["<M-j>"] = {
    { "<Down>", { "i", "c", "s" } },
    -- { "jg_", { "n" } },
    { "<down>", "t" },
  },
  -- ["<C-j>"] = {
  --   "+",
  --   "n",
  -- },
  ["<M-w><M-k>"] = {
    "<C-o>-",
    "i",
  },
  ["<M-e><M-k>"] = {
    "<Esc>kg_a",
    "i",
  },
  ["<M-w><M-j>"] = {
    "<C-o>+",
    "i",
  },
  ["<M-e><M-j>"] = {
    "<Esc>jg_a",
    "i",
  },
  -- ["<M-C-j>"] = {
  --   "<C-W>j^",
  --   "n"
  -- },
  -- insert mode move: h,
  ["<M-h>"] = {
    { "<left>", { "i", "c", "s" } },
    -- { "hi", { "n" } },
    { "<left>", "t" },
  },
  -- ["<M-C-h>"] = {
  --   "<C-W>h^",
  --   "n"
  -- },
  -- insert mode move: l,
  ["<M-l>"] = {
    { "<right>", { "i", "c", "s" } },
    -- { "la", "n" },
    -- { "<C-W>l^", { "n" } },
    { "<right>", "t" },
  },
  -- ["<M-C-l>"] = {
  --   "<C-W>l^",
  --   "n"
  -- },
  -- insert mode move: exclusive words like e,
  ["<M-space><M-i>"] = {
    "<Esc>gea",
    "i",
  },
  -- insert mode move: exclusive words like E,
  ["<M-space><M-S-i>"] = {
    { "<C-o>gE", { "i" } },
  },
  -- insert mode move: exclusive words like w,
  ["<M-space><M-o>"] = {
    { "<S-right>", "i" },
  },
  -- insert mode move: exclusive words like W,
  ["<M-space><M-S-o>"] = {
    { "<C-o>W", "i" },
  },
  -- -- insert mode move: exclusive words like e,
  -- ["<M-C-i>"] = {
  --   { "<Esc>gea", { "i" } },
  -- },
  -- -- insert mode move: exclusive words like E,
  -- ["<M-C-S-i>"] = {
  --   { "<Esc>gEa", { "i" } },
  -- },
  -- -- insert mode move: exclusive words like w,
  -- ["<M-C-o>"] = {
  --   { "<S-right>", { "i" } },
  -- },
  -- -- insert mode move: exclusive words like W,
  -- ["<M-C-S-o>"] = {
  --   { "<Esc>Wi", { "i" } },
  -- },
  -- insert mode move: like H,
  ["<M-S-h>"] = {
    { "<C-o>3h", "i" },
    { "<left><left><left><left><left>", "t" },
  },
  -- insert mode move: like J,
  ["<M-S-j>"] = {
    { "<C-o>3j", "i" },
    { "<down><down><down><down><down>", "t" },
  },

  -- insert mode move: like K,
  ["<M-S-k>"] = {
    { "<C-o>3k", "i" },
    { "<up><up><up><up><up>", "t" },
  },
  -- insert mode move: like L,
  ["<M-S-l>"] = {
    { "<C-o>3l", { "i" } },
    { "<right><right><right><right><right>", "t" },
  },
  -- insert mode move: screen left,
  ["<M-1><M-h>"] = { "<C-o>g0", "i" },
  ["<M-space>h"] = { "<C-o>g0", "i" },
  -- insert mode move: screen right,
  ["<M-1><M-l>"] = { "<C-o>g$", "i" },
  ["<M-space>l"] = { "<C-o>g$", "i" },
  -- insert mode move: screen bottom,
  ["<M-1><M-j>"] = { "<C-o>L", "i" },
  ["<M-space>j"] = { "<C-o>L", "i" },
  -- insert mode move: screen top,
  ["<M-1><M-k>"] = { "<C-o>H", "i" },
  ["<M-space>k"] = { "<C-o>H", "i" },
  -- insert mode move: screen center,
  ["<M-1><M-m>"] = { "<C-o>gm", "i" },
  ["<M-space>m"] = { "<C-o>gm", "i" },
  -- insert mode move: screen center col,
  ["<M-1><M-n>"] = { "<C-o>M", "i" },
  ["<M-space>n"] = { "<C-o>M", "i" },
  -- insert mode move: Home(ignore space),
  ["<M-space><M-h>"] = {
    { "<C-o>I", "i" },
    { "<C-G>^<C-G>", "s" },
    { "<Home>", "t" },
  },
  -- insert mode move: End,
  ["<M-space><M-l>"] = {
    { "<C-o>A", "i" },
    { "<C-G>g_<C-G>", "s" },
    { "<End>", "t" },
  },
  ["<M-space><M-space><M-l>"] = {
    "<End>",
    { "i", "c", "s" },
  },
  -- insert mode move: Home,
  ["<M-space><M-space><M-h>"] = {
    "<Home>",
    { "i", "c", "s" },
  },
  ["<M-space><M-k>"] = {
    { "<Up><End>", "i" },
  },
  -- insert mode move: Up Home,
  ["<M-space><M-space><M-k>"] = { "<Up><Home>", { "i" } },
  -- insert mode move: Down End
  ["<M-space><M-j>"] = {
    { "<Down><End>", "i" },
  },
  -- insert mode move: Down Home,
  ["<M-space><M-space><M-j>"] = { "<Down><Home>", { "i" } },

  ["0m"] = {
    function()
      require("custom.plugins.move.magic-move").move()
    end,
    "n",
  },
  ["<space>h"] = {
    {
      function()
        require("builtin.start-end-move").first_non_blank_character()
      end,
      "n",
    },
    { "^", "x" },
    --- contains the character under the cursor
    { "v^", "o" },
    desc = "Move to the first non-blank character of the line",
  },
  ["<space>l"] = {
    {
      function()
        require("builtin.start-end-move").last_non_blank_character()
      end,
      "n",
    },
    { "g_", { "x", "o" } },
    desc = "Move to the last non-blank character of the line",
  },
  ["<space><space>h"] = {
    {
      function()
        require("builtin.start-end-move").first_character()
      end,
      "n",
    },
    { "0", "x" },
    --- contains the character under the cursor
    { "v0", "o" },
    desc = "Move to the first character of the line",
  },
  ["<space><space>l"] = {
    {
      function()
        require("builtin.start-end-move").last_character()
      end,
      "n",
    },
    {
      "$",
      "o",
    },
    {
      "$h",
      "x",
    },
    desc = "Move to the last character of the line",
  },
}
