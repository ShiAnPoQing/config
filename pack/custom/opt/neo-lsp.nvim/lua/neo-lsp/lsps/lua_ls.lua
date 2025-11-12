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
          "/usr/share/lua/5.4/?.lua", -- LuaSocket
          "/usr/share/lua/5.4/?/init.lua",
        },
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          "/usr/share/lua/5.4",
          "~/.local/share/LuaAddons",
          -- '${3rd}/luv/library'
          -- '${3rd}/busted/library'
        },
      },
    },
  },
  on_attach = function(client, bufnr)
    -- require("neo-winbar.winbar").attach(client, bufnr)
  end,
}
