return {
  name = "bufferman.nvim",
  key = {
    ["<leader><leader>b"] = {
      function()
        require("bufferman").bufferman()
      end,
      "n",
    },
  },
  config = function()
    require("bufferman").setup({})
  end,
}
