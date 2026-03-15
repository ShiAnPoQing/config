return {
  "folke/snacks.nvim",
  lazy = false,
  priority = 1000,
  key = {
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
    -- ["<leader>z"] = {
    --   function()
    --     Snacks.zen()
    --   end,
    --   "n",
    --   desc = "Toggle Zen Mode",
    -- },
  },
  config = function()
    require("snacks").setup({
      bigfile = { enabled = true },
      dashboard = { enabled = false },
      explorer = { enabled = true },
      indent = { enabled = true, char = "│", animate = { enabled = false } },
      input = { enabled = true },
      picker = { enabled = true },
      notifier = { enabled = false },
      quickfile = { enabled = true },
      scope = { enabled = false },
      scroll = { enabled = false },
      -- statuscolumn = { enabled = true },
      words = { enabled = true },
    })
  end,
}
