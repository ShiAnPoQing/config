return {
  name = "buffer.nvim",
  key = {
    ["<leader>8"] = {
      function()
        require("buffer").buffer()
      end,
      "n",
      desc = "Buffer",
    },
  },
  config = function()
    require("buffer").setup()
  end,
}
