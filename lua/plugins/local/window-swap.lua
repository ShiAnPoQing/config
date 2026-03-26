return {
  name = "window-swap.nvim",
  key = {
    ["<M-]>"] = {
      function()
        require("window-swap").window_swap(1)
      end,
      "n",
      desc = "Swap adjacent windows",
    },
    ["<M-[>"] = {
      function()
        require("window-swap").window_swap(-1)
      end,
      "n",
      desc = "Swap adjacent windows",
    },
  },
}
