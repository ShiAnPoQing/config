return {
  name = "simple-translate.nvim",
  key = {
    ["<leader>1"] = {
      function()
        require("simple-translate").visual_translate()
      end,
      "x",
      desc = "Translate visual selection",
    },
  },
  config = function() end,
}
