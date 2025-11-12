return {
  name = "buffer-manage.nvim",
  keys = {
    ["<leader>bm"] = {
      function()
        local function callback()
          require("buffer-manage").buffer_manage()
          require("repeat").set_operation(callback)
        end
        callback()
      end,
      "n",
    },
    ["<leader><leader>bm"] = {
      function()
        require("buffer-manage")._buffer_manage({ position = "right" })
      end,
      "n",
    },
  },
  config = function()
    require("buffer-manage").setup()
  end,
}
