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
    "tsx",
  },
  -- root_dir = function(bufnr, on_dir)
  -- local root_dir = vim.fn.getcwd()
  -- local lines = vim.fn.readfile(root_dir .. "/package.json")
  -- local line = table.concat(lines, "")
  -- local is_vue_project = line:match("vue")
  --
  -- if not is_vue_project then
  --   on_dir(root_dir)
  -- end
  -- end,
  init_options = {
    hostInfo = "neovim",
  },
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
