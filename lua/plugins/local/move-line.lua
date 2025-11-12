return {
  name = "move-line",
  keys = {
    ["<C-down>"] = {
      function()
        local function callback()
          require("move-line").move_line("down")
          require("repeat").set_operation(callback)
        end
        callback()
      end,
      { "n", "i", "x" },
    },
    ["<C-up>"] = {
      function()
        local function callback()
          require("move-line").move_line("up")
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
