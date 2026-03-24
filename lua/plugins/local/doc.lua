return {
  name = "neovim-doc-cn",
  lazy = false,
  depend = "MunifTanjim/nui.nvim",
  key = {
    ["<space>t"] = {
      function()
        require("neovim-doc-cn.core").diff()
      end,
      "n",
    },
  },
  config = function()
    require("neovim-doc-cn").setup()
  end,
}
