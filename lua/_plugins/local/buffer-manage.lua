return {
  name = "buffer-manage.nvim",
  keys = {
    ["<leader>bm"] = {
      function()
        require("buffer-manage").buffer_manage()
        require("repeat"):set(function()
          require("buffer-manage").buffer_manage()
        end)
      end,
      "n",
    },
    ["<leader><leader>bm"] = {
      function()
        require("buffer-manage")._buffer_manage({ position = "right" })
        -- require("repeat"):set(function()
        --   require("buffer-manage").buffer_manage()
        -- end)
      end,
      "n",
    },
  },
  config = function()
    require("buffer-manage").setup()
  end,
}
