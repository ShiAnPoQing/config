return {
  dir = vim.fn.stdpath("config") .. "/lua/custom/plugins/lsp",
  name = "custom-lsp",
  event = "BufReadPre",
  config = function(opt)
    require("custom.plugins.lsp").setup({
      enable = function(opts)
        return {
          opts.lua,
          opts.ts,
          opts.vue,
          opts.clangd,
          opts.html,
          opts.css,
          opts.json,
        }
      end,
    })
  end,
}
