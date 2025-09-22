return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/tag-peek.nvim",
  name = "tag-peek",
  keys = {
    {
      "<leader>tP",
      function()
        require("tag-peek").peek()
      end,
    },
  },
  config = function()
    require("tag-peek").setup({})
  end,
}
