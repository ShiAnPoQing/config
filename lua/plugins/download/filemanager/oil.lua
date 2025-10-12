return {
  "stevearc/oil.nvim",
  depend = { "echasnovski/mini.icons" },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  keys = {
    ["<leader>oi"] = {
      "<cmd>Oil<cr>",
      "n",
    },
  },
  config = function()
    require("oil").setup()
  end,
}
