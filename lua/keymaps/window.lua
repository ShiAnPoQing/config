return {
  -- exchange window
  ["<M-x>"] = {
    function()
      require("win-action").windowExchange()
    end,
    "n",
  },
  -- jump window
  ["<M-g>"] = {
    function()
      require("win-action").windowJump()
    end,
    "n",
  },
  -- resize window
  ["<M-down>"] = { ":resize +3<CR>", { "n" } },
  ["<M-up>"] = { ":resize -3<CR>", { "n" } },
  ["<M-right>"] = { ":vertical resize -3<CR>", { "n" } },
  ["<M-left>"] = { ":vertical resize +3<CR>", { "n" }, { silent = true } },

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
  ["<C-M-=>"] = { "<C-W>=", "n" },
  ["<C-M-->"] = { "<C-W>|<C-W>_^", "n" },
  ["<C-M-n>"] = { "<C-W>n", "n" },
  ["<space><C-M-n>"] = {
    function()
      vim.api.nvim_exec2([[
    vsplit
    e n
    ]], {})
    end,
    "n"
  },
  ["<C-M-space><C-M-n>"] = {
    function()
      vim.api.nvim_exec2([[
    vsplit
    e n
    ]], {})
    end,
    "n"
  },
  ["<M-S-l>"] = {
    function()
      require("windows-layout").win_exchange("right")
    end,
    "n"
  },
  ["<M-S-h>"] = {
    function()
      require("windows-layout").win_exchange("left")
    end,
    "n"
  },
  ["<M-S-j>"] = {
    function()
      require("windows-layout").win_exchange("down")
    end,
    "n"
  },
  ["<M-S-k>"] = {
    function()
      require("windows-layout").win_exchange("up")
    end,
    "n"
  },
  ["<M-S-P>"] = {
    function()
      require("windows-layout").exchange_pre()
    end,
    "n"
  },
  ["<M-S-N>"] = {
    function()
      require("windows-layout").exchange_next()
    end,
    "n"
  },
  ["<M-q>"] = {
    "<C-w>q",
    "n"
  },
  ["<C-M-i>"] = {
    "<cmd>WinShift<cr>",
    "n"
  },
  ["<C-M-o>"] = { "<cmd>only<cr>", "n" }
}
