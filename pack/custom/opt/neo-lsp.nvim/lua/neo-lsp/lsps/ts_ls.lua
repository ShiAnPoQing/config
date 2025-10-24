return {
  cmd = { "typescript-language-server", "--stdio" },
  root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
  filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.jsx",
  },
  init_options = {
    hostInfo = "neovim",
  },
  on_attach = function(client, bufnr)
    -- vim.lsp.completion.enable(true, client.id, bufnr, {
    --   autotrigger = true,
    --   -- convert = function(item)
    --   --   return { abbr = item.label:gsub("%b()", "") }
    --   -- end,
    -- })
  end,
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
      referencesCodeLens = { enabled = false },
      implementationsCodeLens = { enabled = true },
    },
  },
}
