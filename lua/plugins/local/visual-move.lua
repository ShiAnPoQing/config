return {
  name = "visual-move.nvim",
  keys = {
    ["<M-l>"] = {
      function()
        require("visual-move").visual_move("right")
      end,
      "v",
    },
    ["<C-l>"] = {
      function()
        require("visual-move").visual_move("right")
      end,
      "s",
    },
    ["<C-h>"] = {
      function()
        require("visual-move").visual_move("left")
      end,
      "s",
    },
    ["<M-h>"] = {
      function()
        require("visual-move").visual_move("left")
      end,
      "v",
    },
    ["<M-k>"] = {
      function()
        require("visual-move").visual_move("up")
      end,
      "v",
    },
    ["<M-j>"] = {
      function()
        require("visual-move").visual_move("down")
      end,
      "v",
    },
    ["<M-S-l>"] = {
      function()
        vim.v.count1 = 3
        require("visual-move").visual_move("right")
      end,
      "v",
    },
    ["<M-S-h>"] = {
      function()
        vim.v.count1 = 3
        require("visual-move").visual_move("left")
      end,
      "v",
    },
    ["<M-S-k>"] = {
      function()
        vim.v.count1 = 3
        require("visual-move").visual_move("up")
      end,
      "v",
    },
    ["<M-S-j>"] = {
      function()
        vim.v.count1 = 3
        require("visual-move").visual_move("down")
      end,
      "v",
    },
  },
  config = function(opt)
    require("visual-move").setup()
  end,
}
