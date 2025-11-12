return {
  "folke/snacks.nvim",
  priority = 1000,
  keys = {
    ["<leader>e"] = {
      function()
        Snacks.explorer()
      end,
      "n",
      desc = "File Explorer",
    },
    ["<leader>,"] = {
      function()
        Snacks.picker.buffers()
      end,
      "n",
      desc = "Buffers",
    },
    ["<leader>z"] = {
      function()
        Snacks.zen()
      end,
      "n",
      desc = "Toggle Zen Mode",
    },
  },
  config = function()
    require("snacks").setup({
      bigfile = { enabled = true },
      dashboard = { enabled = false },
      explorer = { enabled = true },
      indent = { enabled = true },
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = true },
      scope = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = true },
    })
  end,
}
