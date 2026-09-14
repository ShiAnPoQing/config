return {
  name = "move-line",
  key = {
    ["<C-M-j>"] = {
      function()
        local function callback()
          require("move-line").move_line(vim.v.count1)
          require("repeat").set_operation(callback)
        end
        callback()
      end,
      desc = "Move line [count] down",
      { "n", "i", "x" },
    },
    ["<C-M-k>"] = {
      function()
        local function callback()
          require("move-line").move_line(-vim.v.count1)
          require("repeat").set_operation(callback)
        end
        callback()
      end,
      desc = "Move line [count] up",
      { "n", "i", "x" },
    },
  },
  config = function()
    require("move-line").setup({})
  end,
}
