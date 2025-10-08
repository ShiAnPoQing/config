return {
  name = "buffer-manage.nvim",
  keys = {
    ["<leader>bm"] = {
      function()
        require("buffer-manage").buffer_manage()
      end,
      "n"
    }
  },
  config = function()
    require("buffer-manage").setup()
  end,
}
