return {
  "mikavilpas/yazi.nvim",
  depend = {
    "nvim-lua/plenary.nvim",
  },
  key = {
    ["<leader>Y"] = {
      "<cmd>Yazi<cr>",
      "n",
      desc = "Open yazi",
    },
  },
  config = function()
    require("yazi").setup({})
  end,
}
