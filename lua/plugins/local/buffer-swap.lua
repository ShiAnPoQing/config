return {
  name = "buffer-swap.nvim",
  key = {
    ["<M-S-h>"] = {
      function()
        require("buffer-swap").buffer_swap("left")
      end,
      "n",
      desc = "Swap buffers with the left window",
    },
    ["<M-S-l>"] = {
      function()
        require("buffer-swap").buffer_swap("right")
      end,
      "n",
      desc = "Swap buffers with the right window",
    },
    ["<M-S-j>"] = {
      function()
        require("buffer-swap").buffer_swap("down")
      end,
      "n",
      desc = "Swap buffers with the below window",
    },
    ["<M-S-k>"] = {
      function()
        require("buffer-swap").buffer_swap("up")
      end,
      "n",

      desc = "Swap buffers with the above window",
    },
  },
}
