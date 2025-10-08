return {
  name = "tag-peek.nvim",
  keys = {
    ["<leader>tP"] = {
      function()
        require("tag-peek").peek()
      end,
      "n",
    },
  },
  config = function()
    require("tag-peek").setup({})
  end,
}
