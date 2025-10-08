return {
  name = "code-action.nvim",
  keys = {
    ["<leader>ca"] = {
      function()
        require("code-action").show()
      end,
      "n",
    },
  },
  config = function(opt)
    require("code-action").setup()
  end,
}
