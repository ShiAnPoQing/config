return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/treesitter-textobject.nvim",
  name = "treesitter-textobject",
  keys = {
    {
      "<space>fn",
      function()
        require("treesitter-textobject").textobject({
          language = "typescriptreact",
          query = "function.name",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "typescriptreact",
    },
    {
      "<space>fn",
      function()
        require("treesitter-textobject").textobject({
          language = "lua",
          query = "function.name",
          scm = "textobjects",
        })
      end,
      mode = { "x", "o" },
      ft = "lua",
    },
  },
  config = function(opt)
    require("treesitter-textobject").setup()
  end,
}
