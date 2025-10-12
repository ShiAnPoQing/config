return {
  name = "open-terminal.nvim",
  cmd = { "OpenTerminal" },
  keys = {
    ["<leader>tm"] = {
      function()
        require("open-terminal").open_terminal({
          direction = "float",
        })
      end,
      "n",
      desc = "Open Terminal",
    },
  },
  config = function(opt)
    require("open-terminal").setup()
  end,
}
