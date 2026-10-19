return {
  {
    "nvim-mini/mini.nvim",
    lazy = true,
  },
  {
    "nvim-mini/mini.icons",
    lazy = true,
    config = function() end,
  },
  {
    "nvim-mini/mini.statusline",
    lazy = false,
    depend = { "nvim-mini/mini.icons" },
    config = function()
      require("mini.statusline").setup()
    end,
  },
}
