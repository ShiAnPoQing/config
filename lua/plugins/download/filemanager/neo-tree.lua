return {
  "nvim-neo-tree/neo-tree.nvim",
  version = "v3.x",
  depend = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  keys = {
    ["<leader>e"] = {
      function()
        require("neo-tree.command").execute({ toggle = true, reveal_force_cwd = false })
      end,
      "n",
      desc = "Explorer NeoTree (Root Dir)",
    },
    ["<leader>be"] = {
      function()
        require("neo-tree.command").execute({ source = "buffers", toggle = true })
      end,
      "n",
      desc = "Buffer Explorer",
    },
  },
  config = function()
    require("neo-tree").setup({})
  end,
}
