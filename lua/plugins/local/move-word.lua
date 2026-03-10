return {
  name = "move-word.nvim",
  key = {
    ["<C-left>"] = {
      function()
        local function callback()
          require("move-word").move_word(-1)
          require("repeat").set_operation(callback)
        end
        callback()
      end,
      { "i", "n" },
      desc = "Move word left",
    },
    ["<C-right>"] = {
      function()
        local function callback()
          require("move-word").move_word(1)
          require("repeat").set_operation(callback)
        end
        callback()
      end,
      { "i", "n" },
      desc = "Move word right",
    },
  },
}
