return {
  name = "move-line",
  key = {
    ["<C-M-j>"] = {
      function()
        require("move-line").move_line(vim.v.count1)
      end,
      desc = "Move line [count] down",
      { "n", "i", "x" },
    },
    ["<C-M-k>"] = {
      function()
        require("move-line").move_line(-vim.v.count1)
      end,
      desc = "Move line [count] up",
      { "n", "i", "x" },
    },
  },
  config = function()
    require("move-line").setup({})
  end,
}
