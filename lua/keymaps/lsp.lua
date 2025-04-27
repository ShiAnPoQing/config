return {
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
      vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
      vim.api.nvim_feedkeys("zz", "n", false)
    end,
    "n",
  },
  -- Goto next WARN diagnostic
  ["]w"] = {
    function()
      vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
      vim.api.nvim_feedkeys("zz", "n", false)
    end,
    "n",
  },
  -- Goto next error diagnostic
  ["]e"] = {
    function()
      vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
      vim.api.nvim_feedkeys("zz", "n", false)
    end,
    "n",
  },
  -- Goto previous error diagnostic
  ["[e"] = {
    function()
      vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
      vim.api.nvim_feedkeys("zz", "n", false)
    end,
    "n",
  },
  ["[d"] = {
    function()
      vim.diagnostic.goto_prev({})
      vim.api.nvim_feedkeys("zz", "n", false)
    end,
    "n",
  },
  ["]d"] = {
    function()
      vim.diagnostic.goto_next({})
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
