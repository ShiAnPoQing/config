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
  ["<M-->"] = { "<C-W>|<C-W>_", "n" },
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
  ["<M-q>"] = {
    "<C-w>q",
    "n",
  },
}
