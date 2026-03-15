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
      desc = "Move line down",
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
      desc = "Move line up",
      { "n", "i", "x" },
    },
    ["<C-down>"] = {
      function()
        local function callback()
          require("move-line").move_line(vim.v.count1)
          require("repeat").set_operation(callback)
        end
        callback()
      end,
      desc = "Move line down",
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
      desc = "Move line up",
      { "n", "i", "x" },
    },
  },
  config = function()
    require("move-line").setup({})
  end,
}
