return {
  name = "move-line",
  key = {
    ["<C-down>"] = {
      function()
        local function callback()
          require("move-line").move_line(vim.v.count1)
          require("repeat").set_operation(callback)
        end
        callback()
      end,
      { "n", "i", "x" },
    },
    ["<C-up>"] = {
      function()
        local function callback()
          require("move-line").move_line(-vim.v.count1)
          require("repeat").set_operation(callback)
        end
        callback()
      end,
      { "n", "i", "x" },
    },
  },
  config = function()
    require("move-line").setup({})
  end,
}
