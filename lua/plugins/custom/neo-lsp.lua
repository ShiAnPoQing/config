return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/neo-lsp.nvim",
  name = "neo-lsp",
  event = "BufReadPre",
  config = function(opt)
    require("neo-lsp").setup({
      enable = function(opts)
        return {
          opts.lua,
          opts.ts,
          opts.vue,
          opts.clangd,
          opts.html,
          opts.css,
          opts.json,
          opts.qml,
        }
      end,
    })
  end,
}
