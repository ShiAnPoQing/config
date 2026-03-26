return {
  ["<M-v>"] = {
    "<cmd>vsplit<cr>",
    "n",
  },
  ["<M-S-V>"] = {
    "<cmd>split<cr>",
    "n",
  },
  ["<M-=>"] = { "<C-W>=", "n" },
  ["<M-->"] = { "<C-W>|<C-W>_", "n" },
  -- ["<M-n>"] = { "<C-W>n", "n" },
  -- ["<space><C-M-n>"] = {
  --   function()
  --     vim.api.nvim_exec2(
  --       [[
  --   vsplit
  --   e n
  --   ]],
  --       {}
  --     )
  --   end,
  --   "n",
  -- },
  -- ["<C-M-space><C-M-n>"] = {
  --   -- function()
  --   --   vim.api.nvim_exec2(
  --   --     [[
  --   -- vsplit
  --   -- e n
  --   -- ]],
  --   --     {}
  --   --   )
  --   -- end,
  --   -- "n",
  -- },
  ["<M-q>"] = {
    "<C-w>q",
    "n",
    desc = "Quit current window",
  },
  ["<M-right>"] = {
    function()
      require("builtin.window-resize").resize("increase", "horizontal")
    end,
    "n",
  },
  ["<M-left>"] = {
    function()
      require("builtin.window-resize").resize("decrease", "horizontal")
    end,
    "n",
  },
  ["<M-up>"] = {
    function()
      require("builtin.window-resize").resize("decrease", "vertical")
    end,
    "n",
  },
  ["<M-down>"] = {
    function()
      require("builtin.window-resize").resize("increase", "vertical")
    end,
    "n",
  },
  ["<M-space><M-k>"] = {
    "<C-W>K",
    { "n", "x" },
    desc = "Move the current window to be at the very top, using the full width of the screen",
  },
  ["<M-space><M-j>"] = {
    "<C-W>J",
    { "n", "x" },
    desc = "Move the current window to be at the very bottom, using the full width of the screen",
  },
  ["<M-space><M-h>"] = {
    "<C-W>H",
    { "n", "x" },
    desc = "Move the current window to be at the far left, using the full height of the screen",
  },
  ["<M-space><M-l>"] = {
    "<C-W>L",
    { "n", "x" },
    desc = "Move the current window to be at the far right, using the full height of the screen",
  },
}
