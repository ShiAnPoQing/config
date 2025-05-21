return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "biome",
      },
    },
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      -- ensure_installed = { "lua_ls", "tsserver", "cssls", "html", "clangd" },
    end,
  },
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      "saghen/blink.cmp"
    },
    opts = function()
      return {
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = {
            spacing = 4,
            source = "if_many",
            prefix = "●",
            -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
            -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
            -- prefix = "icons",
          },
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = " ",
              [vim.diagnostic.severity.WARN] = " ",
              [vim.diagnostic.severity.HINT] = " ",
              [vim.diagnostic.severity.INFO] = " ",
            },
          },
        },
        inlay_hints = {
          enabled = true,
          -- exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
        },
        codelens = {
          enabled = true,
        },
        servers = {
          -- tailwindcss = {}
        }
      }
    end,
    config = function(_, opts)
      -- require("neodev").setup({})
      local lspconfig = require("lspconfig")
      local mason_registry = require("mason-registry")
      local vue_language_server =
      "C:/Users/24893/AppData/Local/nvim-data/mason/packages/vue-language-server/node_modules/@vue/language-server"


      for server, config in pairs(opts.servers) do
        -- passing config.capabilities to blink.cmp merges with the capabilities in your
        -- `opts[server].capabilities, if you've defined it
        config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
        lspconfig[server].setup(config)
      end


      lspconfig.clangd.setup({})
      -- lspconfig.volar.setup {}
      lspconfig.ts_ls.setup({
        init_options = {
          plugins = {
            {
              name = "@vue/typescript-plugin",
              location = vue_language_server,
              languages = { "vue", "javascript", "typescript" }
            }
          },
          filetypes = { "vue", "typescript", "javascript", "javascriptreact", "typescriptreact" }
        },
        on_attach = function(client, bufnr)
          -- if client.supports_method("textDocument/codeLens", { bufnr = bufnr }) then
          -- 	vim.lsp.codelens.refresh()
          -- 	vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
          -- 		buffer = bufnr,
          -- 		callback = function()
          -- 			vim.lsp.codelens.refresh()
          -- 		end,
          -- 	})
          -- end
        end,
        filetypes = { "vue", "typescript", "javascript", "javascriptreact", "typescriptreact" }
        -- settings = {
        --   typescript = {
        --     inlayHints = {
        --       includeInlayParameterNameHints = "all",
        --       includeInlayParameterNameHintsWhenArgumentMatchesName = true,
        --       includeInlayFunctionParameterTypeHints = true,
        --       includeInlayVariableTypeHints = true,
        --       includeInlayVariableTypeHintsWhenTypeMatchesName = true,
        --       includeInlayPropertyDeclarationTypeHints = true,
        --       includeInlayFunctionLikeReturnTypeHints = true,
        --       includeInlayEnumMemberValueHints = true,
        --     },
        --     referencesCodeLens = { enabled = true },
        --     implementationsCodeLens = { enabled = true },
        --   },
        -- },
      })
      lspconfig.cssls.setup({})
      lspconfig.html.setup({})
      lspconfig.texlab.setup({})
      lspconfig.jsonls.setup({})
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            completion = {
              callSnippet = "Replace",
            },
            codeLens = {
              enable = true,
            },
            hint = {
              enable = true,
            },
          },
        },
      })
      -- lspconfig.tailwindcss.setup {}
      vim.keymap.set("n", ";k", vim.lsp.buf.hover, {})
    end,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    config = function()
      require("mason-tool-installer").setup({
        -- ensure_installed = { "stylua", "eslint_d" },
      })
    end,
  },
}
