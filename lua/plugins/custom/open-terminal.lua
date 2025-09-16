return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/open-terminal.nvim",
  name = "open-terminal",
  cmd = { "OpenTerminal" },
  keys = {
    {
      "<leader>tm",
      function()
        require("open-terminal").open_terminal({
          direction = "float",
        })
      end,
      desc = "Open Terminal",
      mode = "n",
    },
  },
  config = function(opt)
    require("open-terminal").setup()
  end,
}
