return {
  "pmizio/typescript-tools.nvim",
  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  opts = {},
  ft = "typescript",
  config = function()
    require("typescript-tools").setup({})
    vim.keymap.set("n", "<leader>oi", "<cmd>TSToolsOrganizeImports<cr>")
    vim.keymap.set("n", "<leader>si", "<cmd>TSToolsSortImports<cr>")
    vim.keymap.set("n", "<leader>mi", "<cmd>TSToolsAddMissingImports<cr>")
  end,
}
