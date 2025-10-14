return {
  ["<leader>k"] = {
    function()
      vim.lsp.buf.hover()
    end,
    "n",
    desc = "LSP Hover",
  },
  -- Run lsp codelens
  ["<leader>lc"] = {
    function()
      vim.lsp.codelens.run()
    end,
    "n",
    desc = "[L]sp [C]odelens",
  },
  -- Refresh lsp codelens
  ["<leader>cR"] = {
    function()
      vim.lsp.codelens.refresh()
    end,
    "n",
  },
  -- show inlay_hint
  ["<leader>ih"] = {
    function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
    end,
    "n",
    desc = "Toggle inlay hint",
  },
  ["gd"] = {
    function()
      vim.lsp.buf.definition()
    end,
    "n",
    desc = "Goto Lsp definition",
  },
  ["gy"] = {
    function()
      vim.lsp.buf.type_definition()
    end,
    "n",
    desc = "Got Lsp type definition",
  },
}
