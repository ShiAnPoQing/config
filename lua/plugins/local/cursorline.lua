return {
  name = "cursorline.nvim",
  lazy = false,
  key = {
    ["<leader>csl"] = {
      function()
        require("builtin.cursorline"):toggle()
      end,
      "n",
      desc = "Switch cursorline[only one cursorline]",
    },
  },
  config = function()
    require("cursorline").setup()
  end,
}
