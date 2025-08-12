return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/window-resize",
  keys = {
    {
      "<M-down>",
      function()
        require("window-resize").window_resize({ type = "increase", direction = "vertical" })
      end,
    },
    {
      "<M-up>",
      function()
        require("window-resize").window_resize({ type = "decrease", direction = "vertical" })
      end,
    },
    {
      "<M-right>",
      function()
        require("window-resize").window_resize({ type = "increase", direction = "horizontal" })
      end,
    },
    {
      "<M-left>",
      function()
        require("window-resize").window_resize({ type = "decrease", direction = "horizontal" })
      end,
    },
  },
  name = "window-resize",
  config = function(opt)
    require("window-resize").setup({})
  end,
}
