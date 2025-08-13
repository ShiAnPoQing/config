return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/window-exchange",
  keys = {
    {
      "<M-S-l>",
      function()
        require("window-exchange").window_exchange("right")
      end,
    },
    {
      "<M-S-h>",
      function()
        require("window-exchange").window_exchange("left")
      end,
    },
    {
      "<M-S-j>",
      function()
        require("window-exchange").window_exchange("down")
      end,
    },
    {
      "<M-S-k>",
      function()
        require("window-exchange").window_exchange("up")
      end,
    },
  },
  name = "window-exchange",
  config = function(opt)
    require("window-exchange").setup()
  end,
}
