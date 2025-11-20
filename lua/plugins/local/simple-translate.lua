return {
  dir = "~/.config/nvim/pack/custom/opt/simple-translate.nvim",
  keys = {
    {
      "<leader>1",
      function()
        require("simple-translate").visual_translate()
      end,
      mode = "x",
    },
  },
  config = function(opt) end,
}
