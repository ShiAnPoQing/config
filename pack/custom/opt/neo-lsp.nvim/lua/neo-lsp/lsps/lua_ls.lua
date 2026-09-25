local root_markers1 = {
  ".emmyrc.json",
  ".luarc.json",
  ".luarc.jsonc",
}
local root_markers2 = {
  ".luacheckrc",
  ".stylua.toml",
  "stylua.toml",
  "selene.toml",
  "selene.yml",
}

---@type vim.lsp.Config
return {
  cmd = { "lua-language-server" },
  filetypes = { "lua" },
  root_markers = vim.fn.has("nvim-0.11.3") == 1 and { root_markers1, root_markers2, { ".git" } }
    or vim.list_extend(vim.list_extend(root_markers1, root_markers2), { ".git" }),
  settings = {
    Lua = {
      codeLens = { enable = true },
      hint = { enable = true, semicolon = "Disable" },
    },
  },
  on_attach = function()
    vim.wo[0][0].foldexpr = vim.lsp.foldexpr
  end,
}

-- return {
--   cmd = { "lua-language-server" },
--   filetypes = { "lua" },
--   root_markers = { ".luarc.json", ".luarc.jsonc" },
--   settings = {
--     Lua = {
--       diagnostics = {
--         globals = { "vim", "require" },
--       },
--       hint = { enable = true },
--       codeLens = { enable = true },
--       runtime = {
--         version = "LuaJIT",
--         path = {
--           "lua/?.lua",
--           "lua/?/init.lua",
--           "/usr/share/lua/5.3/?.lua",
--           "/usr/share/lua/5.3/?/init.lua",
--         },
--       },
--       workspace = {
--         fileOperations = {
--           willRename = true,
--           didRename = true,
--         },
--         checkThirdParty = false,
--         library = {
--           vim.env.VIMRUNTIME,
--           "/usr/share/lua/5.3",
--           -- "~/.local/share/LuaAddons",
--           "${3rd}/luv/library",
--           "${3rd}/busted/library",
--         },
--       },
--     },
--   },
-- }
