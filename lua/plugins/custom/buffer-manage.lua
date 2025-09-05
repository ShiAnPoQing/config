return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/buffer-manage.nvim",
  lazy = false,
  name = "buffer-manage",
  keys = {
    {
      "<leader>bm",
      function()
        require("buffer-manage").buffers()
      end,
    },
  },
  config = function(opt)
    require("buffer-manage").setup()
  end,
}
