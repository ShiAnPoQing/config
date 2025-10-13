return {
  name = "neo-buffer.nvim",
  keys = {
    ["<leader>BM"] = {
      function()
        require("neo-buffer").buffers("right")
      end,
      "n",
    },
  },
  config = function()
    require("neo-buffer").setup({})
  end,
}
