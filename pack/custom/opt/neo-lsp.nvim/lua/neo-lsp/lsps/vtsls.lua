-- https://github.com/vuejs/language-tools/wiki/Neovim

local npm_global_path = vim.fn.system("npm root -g"):gsub("%s$", "")

return {
  cmd = { "vtsls", "--stdio" },
  filetypes = {
    "typescript",
    "javascript",
    "javascriptreact",
    "typescriptreact",
    "vue",
  },
  root_markers = { "tsconfig.json", "package.json", "jsconfig.json", ".git" },
  settings = {
    vtsls = {
      tsserver = {
        globalPlugins = {
          {
            name = "@vue/typescript-plugin",
            -- location = "/usr/lib/node_modules/@vue/language-server",
            location = npm_global_path .. "/@vue/language-server",
            languages = { "vue" },
            configNamespace = "typescript",
          },
        },
      },
    },
  },
}
