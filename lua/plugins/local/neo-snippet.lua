return {
  name = "neo-snippet.nvim",
  keys = {
    [";2"] = {
      function()
        require("neo-snippet").trigger()
      end,
      "i",
    },
  },
  config = function(opt)
    require("neo-snippet").setup({})
  end,
}
