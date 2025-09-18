return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/tabpage-manage.nvim",
  name = "tabpage-manage",
  keys = {
    {
      "<leader>tp",
      function()
        require("tabpage-manage").tabpage_manage()
      end,
    },
  },
  config = function(opt)
    require("tabpage-manage").setup()
  end,
}
