return {
  ["<leader>k"] = {
    function()
      vim.lsp.buf.hover()
    end,
    "n",
  },
  -- Run lsp codelens
  ["<leader>lc"] = {
    function()
      vim.lsp.codelens.run()
    end,
    "n",
    { desc = "[L]sp [C]odelens" },
  },
  -- Refresh lsp codelens
  ["<leader>cR"] = {
    function()
      vim.lsp.codelens.refresh()
    end,
    "n",
  },
  -- QuickFix List show diagnostic
  ["<leader>dq"] = {
    function()
      vim.diagnostic.setqflist()
    end,
    "n",
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
  },
  -- Goto next WARN diagnostic
  ["]w"] = {
    function()
      vim.diagnostic.jump({ severity = vim.diagnostic.severity.WARN, count = 1 })
      vim.api.nvim_feedkeys("zz", "n", false)
    end,
    "n",
  },
  -- Goto next error diagnostic
  ["]e"] = {
    function()
      vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = 1 })
      vim.api.nvim_feedkeys("zz", "n", false)
    end,
    "n",
  },
  -- Goto previous error diagnostic
  ["[e"] = {
    function()
      vim.diagnostic.jump({ severity = vim.diagnostic.severity.ERROR, count = -1 })
      vim.api.nvim_feedkeys("zz", "n", false)
    end,
    "n",
  },
  ["[d"] = {
    function()
      vim.diagnostic.jump({ count = -1 })
      vim.api.nvim_feedkeys("zz", "n", false)
    end,
    "n",
  },
  ["]d"] = {
    function()
      vim.diagnostic.jump({ count = 1 })
      vim.api.nvim_feedkeys("zz", "n", false)
    end,
    "n",
  },
  -- show inlay_hint
  ["<leader>ih"] = {
    function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({}))
    end,
    "n",
  },
}
