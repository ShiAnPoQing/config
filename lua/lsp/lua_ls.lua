vim.lsp.config("lua_ls", {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath("config")
        and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = "LuaJIT",
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          "lua/?.lua",
          "lua/?/init.lua",
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
          -- Depending on the usage, you might want to add additional paths
          -- here.
          -- '${3rd}/luv/library'
          -- '${3rd}/busted/library'
        },
        -- Or pull in all of 'runtimepath'.
        -- NOTE: this is a lot slower and will cause issues when working on
        -- your own configuration.
        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
        -- library = {
        --   vim.api.nvim_get_runtime_file('', true),
        -- }
      },
    })
  end,
  settings = {
    Lua = {},
  },
})

-- vim.lsp.config["luals"] = {
--   -- 启动服务器的命令和参数。
--   cmd = { "lua-language-server" },
--
--   -- 要自动附加的文件类型。
--   filetypes = { "lua" },
--
--   -- 将“根目录”设置为当前缓冲区文件的父目录，该目录包含“.luarc.json”或
--   -- “.luarc.jsonc”文件。共享根目录的文件将复用同一个 LSP 服务器的连接。
--   root_markers = { ".luarc.json", ".luarc.jsonc" },
--
--   -- 要发送到服务器的特定设置。此结构由服务器定义。例如 lua-language-server
--   -- 的结构可在此处找到 https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
--   settings = {
--     Lua = {
--       runtime = {
--         version = "LuaJIT",
--       },
--     },
--   },
-- }
