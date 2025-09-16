return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/code-action.nvim",
  name = "code-action.nvim",
  keys = {
    {
      "<leader>ca",
      function()
        require("code-action").show()
      end,
    },
  },
  config = function(opt)
    require("code-action").setup()
  end,
}
