return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/move-line",
  name = "move-line",
  keys = {
    {
      "<C-down>",
      function()
        require("move-line").move_line("down")
        require("repeat").record({
          name = "move-line",
          callback = function()
            require("move-line").move_line("down")
          end,
        })
      end,
      mode = { "n", "i", "x" },
    },
    {
      "<C-up>",
      function()
        require("move-line").move_line("up")
        require("repeat").record({
          name = "move-line",
          callback = function()
            require("move-line").move_line("up")
          end,
        })
      end,
      mode = { "n", "i", "x" },
    },
  },
  config = function()
    require("move-line").setup({})
  end,
}
