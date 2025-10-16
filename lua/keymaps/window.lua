return {
  -- vsplit current file left-right
  ["<M-v>"] = {
    "<cmd>vsplit<cr>",
    "n",
  },
  ["<M-x>"] = {
    "<C-w>x<C-w>w",
    "n",
    desc = "Swap adjacent windows",
  },
  ["<M-S-V>"] = {
    "<cmd>split<cr>",
    "n",
  },
  ["<M-=>"] = { "<C-W>=", "n" },
  ["<M-->"] = { "<C-W>|<C-W>_", "n" },
  ["<M-n>"] = { "<C-W>n", "n" },
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
      require("builtin.win_resize").resize("increase", "horizontal")
    end,
    "n",
  },
  ["<M-left>"] = {
    function()
      require("builtin.win_resize").resize("decrease", "horizontal")
    end,
    "n",
  },
  ["<M-up>"] = {
    function()
      require("builtin.win_resize").resize("decrease", "vertical")
    end,
    "n",
  },
  ["<M-down>"] = {
    function()
      require("builtin.win_resize").resize("increase", "vertical")
    end,
    "n",
  },
  ["<M-S-h>"] = {
    function()
      require("builtin.win_exchange").window_exchange("left")
    end,
    "n",
    desc = "Swap with the window on the left",
  },
  ["<M-S-l>"] = {
    function()
      require("builtin.win_exchange").window_exchange("right")
    end,
    "n",
    desc = "Swap with the window on the right",
  },
  ["<M-S-j>"] = {
    function()
      require("builtin.win_exchange").window_exchange("down")
    end,
    "n",
    desc = "Swap with the window below",
  },
  ["<M-S-k>"] = {
    function()
      require("builtin.win_exchange").window_exchange("up")
    end,
    "n",
    desc = "Swap with the window above",
  },
}
