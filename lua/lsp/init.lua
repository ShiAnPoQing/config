require("lsp.lua_ls")
require("lsp.vue")
require("lsp.ts_ls")
require("lsp.clangd")
require("lsp.html")
require("lsp.css")
require("lsp.json")

vim.diagnostic.config({
  -- virtual_text = {
  --   spacing = 4,
  --   source = "if_many",
  --   prefix = "●",
  -- },
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
})
