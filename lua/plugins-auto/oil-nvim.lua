return {
  "stevearc/oil.nvim",
  opts = {},
  -- Optional dependencies
  dependencies = { "echasnovski/mini.icons" },
  -- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  keys = {
    { ";oi", "<cmd>Oil<cr>" }
  },
  config = function()
    require("oil").setup()
  end,
}
