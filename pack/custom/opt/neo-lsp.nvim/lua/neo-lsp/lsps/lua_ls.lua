return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = { ".luarc.json", ".luarc.jsonc" },
  settings = {
    Lua = {
      diagnostics = {
        globals = { "vim", "require" },
      },
      hint = { enable = true },
      codeLens = { enable = true },
      runtime = {
        version = "LuaJIT",
        path = {
          "lua/?.lua",
          "lua/?/init.lua",
          "/usr/share/lua/5.3/?.lua",
          "/usr/share/lua/5.3/?/init.lua",
        },
      },
      workspace = {
        fileOperations = {
          willRename = true,
          didRename = true,
        },
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          "/usr/share/lua/5.3",
          -- "~/.local/share/LuaAddons",
          "${3rd}/luv/library",
          "${3rd}/busted/library",
        },
      },
    },
  },
  on_attach = function(client, bufnr)
    vim.wo[0][0].foldexpr = vim.lsp.foldexpr
  end,
}
