return {
  "nvim-neo-tree/neo-tree.nvim",
  enabled = true,
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
    "MunifTanjim/nui.nvim",
    -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
  },
  config = function()
    require("plugin-keymap").add({
      ["<leader>be"] = {
        function()
          require("neo-tree.command").execute({ source = "buffers", toggle = true })
        end,
        "n",
        { desc = "Buffer Explorer" },
      },
      ["<leader>e"] = {
        function()
          -- require("neo-tree.command").execute({ toggle = true, dir = vim.uv.cwd() })
          require("neo-tree.command").execute({ toggle = true, reveal_force_cwd = false })
        end,
        "n",
        { desc = "Explorer NeoTree (Root Dir)" },
      },
    })
  end,
}
