return {
  ["n"] = {
    "K",
    "n",
  },
  -- Refresh lsp codelens
  ["<leader>cR"] = {
    function()
      vim.lsp.codelens.refresh()
    end,
    "n",
  },
  ["gd"] = {
    "<C-]>",
    "n",
  },
}
