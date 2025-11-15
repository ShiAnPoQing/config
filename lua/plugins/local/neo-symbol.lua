return {
  name = "neo-symbol.nvim",
  keys = {
    ["<leader>8"] = {
      function()
        require("neo-symbol.core").symbol()
      end,
      "n",
    },
  },
  config = function() end,
}
