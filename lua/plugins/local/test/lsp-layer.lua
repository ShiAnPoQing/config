return {
  name = "lsp-layer.nvim",
  config = function()
    require("lsp-layer").setup()
  end,
  key = {
    ["<leader>ca"] = {
      function()
        require("lsp-layer.code_action"):request():float()
      end,
      { "n", "x" },
      desc = "Code Action(float)",
    },
    ["<leader>gd"] = {
      function()
        require("lsp-layer.definition"):request():tolocation():float()
      end,
      "n",
    },
  },
}
