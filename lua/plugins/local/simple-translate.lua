return {
  name = "simple-translate.nvim",
  depend = "MunifTanjim/nui.nvim",
  key = {
    ["<leader>1"] = {
      function()
        require("simple-translate").visual_translate()
      end,
      "v",
      desc = "Translate visual selection",
    },
  },
  config = function() end,
}
