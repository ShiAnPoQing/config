return {

  -- vsplit current file left-right
  ["<M-v>"] = {
    ":vsplit<cr>",
    "n",
  },
  --? split current file top-bottom
  ["<M-S-V>"] = {
    ":split<cr>",
    "n",
  },
  ["<M-=>"] = { "<C-W>=", "n" },
  ["<M-->"] = { "<C-W>|<C-W>_^", "n" },
  ["<M-n>"] = { "<C-W>n", "n" },
  ["<space><C-M-n>"] = {
    function()
      vim.api.nvim_exec2(
        [[
    vsplit
    e n
    ]],
        {}
      )
    end,
    "n",
  },
  ["<C-M-space><C-M-n>"] = {
    function()
      vim.api.nvim_exec2(
        [[
    vsplit
    e n
    ]],
        {}
      )
    end,
    "n",
  },
  ["<M-S-l>"] = {
    function()
      require("custom.plugins.window-exchange").win_exchange("right")
    end,
    "n",
  },
  ["<M-S-h>"] = {
    function()
      require("custom.plugins.window-exchange").win_exchange("left")
    end,
    "n",
  },
  ["<M-S-j>"] = {
    function()
      require("custom.plugins.window-exchange").win_exchange("down")
    end,
    "n",
  },
  ["<M-S-k>"] = {
    function()
      require("custom.plugins.window-exchange").win_exchange("up")
    end,
    "n",
  },
  ["<M-q>"] = {
    "<C-w>q",
    "n",
  },
  ["<C-M-i>"] = {
    "<cmd>WinShift<cr>",
    "n",
  },
  ["<C-M-o>"] = { "<cmd>only<cr>", "n" },
}
