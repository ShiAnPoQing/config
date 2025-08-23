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
      "<C-l>",
      function()
        require("visual-move").visual_move("right")
      end,
      mode = { "s" },
    },
    {
      "<C-h>",
      function()
        require("visual-move").visual_move("left")
      end,
      mode = { "s" },
    },
    {
      "<M-h>",
      function()
        require("visual-move").visual_move("left")
      end,
      mode = { "v" },
    },
    {
      "<M-k>",
      function()
        require("visual-move").visual_move("up")
      end,
      mode = { "v" },
    },
    {
      "<M-j>",
      function()
        require("visual-move").visual_move("down")
      end,
      mode = { "v" },
    },
    {
      "<M-S-l>",
      function()
        vim.v.count1 = 3
        require("visual-move").visual_move("right")
      end,
      mode = { "v" },
    },
    {
      "<M-S-h>",
      function()
        vim.v.count1 = 3
        require("visual-move").visual_move("left")
      end,
      mode = { "v" },
    },
    {
      "<M-S-k>",
      function()
        vim.v.count1 = 3
        require("visual-move").visual_move("up")
      end,
      mode = { "v" },
    },
    {
      "<M-S-j>",
      function()
        vim.v.count1 = 3
        require("visual-move").visual_move("down")
      end,
      mode = { "v" },
    },
  },
  config = function(opt)
    require("visual-move").setup()
  end,
}
