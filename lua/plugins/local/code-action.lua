return {
  dir = "~/.config/nvim/pack/custom/opt/code-action.nvim",
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
