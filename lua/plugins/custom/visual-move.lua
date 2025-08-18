return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/visual-move.nvim",
  name = "visual-move",
  keys = {
    {
      "<M-l>",
      function()
        require("visual-move").visual_move("right")
      end,
      mode = { "v" },
    },
    {
      "<M-h>",
      function()
        require("visual-move").visual_move("left")
      end,
      mode = { "v" },
    },
  },
  config = function(opt)
    require("visual-move").setup()
  end,
}
