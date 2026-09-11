return {
  name = "native-macro.nvim",
  -- depend = "BrokenSunny/repeat.nvim",
  lazy = false,
  key = {
    ["@"] = {
      function()
        require("native-macro")._repeat()
      end,
      "n",
      desc = "Native macro repeat",
    },
  },
  config = function()
    require("native-macro").setup()
  end,
}
