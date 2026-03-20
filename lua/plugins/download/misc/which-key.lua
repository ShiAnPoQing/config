return {
  "folke/which-key.nvim",
  event = "VimEnter",
  key = {
    ["<leader>?"] = {
      function()
        require("which-key").show({ global = false })
      end,
      "n",
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
  config = function()
    require("which-key").setup({})
  end,
}
