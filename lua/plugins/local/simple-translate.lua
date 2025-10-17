return {
  name = "simple-translate.nvim",
  keys = {
    ["<leader>1"] = {
      function()
        require("simple-translate").visual_translate()
      end,
      "x",
    },
  },
  config = function(opt) end,
}
