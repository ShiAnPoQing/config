return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  enabled = false,
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup({})
    require("plugin-keymap").add({
      ["<leader>be"] = {
        function()
          require("nvim-tree.commands").execute({ source = "buffers", toggle = true })
        end,
        "n",
        { desc = "Buffer Explorer" },
      },
      ["<leader>e"] = {
        function()
          require("nvim-tree.api").tree.toggle({ focus = true })
        end,
        "n",
        { desc = "Explorer NeoTree (Root Dir)" },
      },
    })
  end,
}
