return {
  name = "bufferman.nvim",
  key = {
    ["<leader>8"] = {
      function()
        require("bufferman").bufferman()
      end,
      "n",
      desc = "Buffer",
    },
  },
}
