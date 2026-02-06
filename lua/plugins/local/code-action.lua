return {
  name = "code-action.nvim",
  key = {
    ["<leader>ca"] = {
      function()
        require("code-action").show()
      end,
      "n",
    },
  },
  config = function()
    require("code-action").setup()
  end,
}
