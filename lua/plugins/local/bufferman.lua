return {
  name = "bufferman.nvim",
  key = {
    ["<leader>b"] = {
      function()
        require("bufferman").bufferman()
      end,
      "n",
      desc = "Bufferman",
    },
  },
}
