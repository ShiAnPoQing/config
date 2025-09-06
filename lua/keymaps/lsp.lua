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
  ["<leader>dq"] = {
    function()
      vim.diagnostic.setqflist()
    end,
    "n",
    desc = "Show diagnostic in quickfix list",
  },
  -- Open diagnostic Float Win
  ["<leader>df"] = {
    function()
      vim.diagnostic.open_float({
        border = "rounded",
      })
    end,
    "n",
  },
  -- Goto prev WARN diagnostic
  ["[w"] = {
    function()
      vim.diagnostic.jump({ severity = vim.diagnostic.severity.WARN, count = -1 })
      vim.api.nvim_feedkeys("zz", "n", false)
    end,
    "n",
    desc = "Goto prev WARN diagnostic",
  },
  -- Goto next WARN diagnostic
  ["]w"] = {
    function()
      vim.diagnostic.jump({ severity = vim.diagnostic.severity.WARN, count = 1 })
      vim.api.nvim_feedkeys("zz", "n", false)
    end,
    "n",
    desc = "Goto next WARN diagnostic",
  },
  -- Goto next error diagnostic
  ["]e"] = {
    function()
      vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = 1 })
      vim.api.nvim_feedkeys("zz", "n", false)
    end,
    "n",
    desc = "Goto next error diagnostic",
  },
  -- Goto previous error diagnostic
  ["[e"] = {
    function()
      vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = -1 })
      vim.api.nvim_feedkeys("zz", "n", false)
    end,
    "n",
    desc = "Goto prev ERROR diagnostic",
  },
  ["[d"] = {
    function()
      vim.diagnostic.jump({ count = -1 })
      vim.api.nvim_feedkeys("zz", "n", false)
    end,
    "n",
    desc = "Goto prev diagnostic",
  },
  ["]d"] = {
    function()
      vim.diagnostic.jump({ count = 1 })
      vim.api.nvim_feedkeys("zz", "n", false)
    end,
    "n",
    desc = "Goto next diagnostic",
  },
  -- show inlay_hint
  ["<leader>ih"] = {
    function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
    end,
    "n",
    desc = "Toggle inlay hint",
  },
}
