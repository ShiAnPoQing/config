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
        ft = "lua",
        opts = {
          library = {
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
          },
        },
      },
      "saghen/blink.cmp"
    },
    config = function(_, opts)
      local lspconfig = require("lspconfig")

      vim.diagnostic.config({
        -- virtual_text = {
        --   spacing = 4,
        --   source = "if_many",
        --   prefix = "●",
        -- },
        virtual_text = false,
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
          },
        },
      })

      -- for server, config in pairs(opts.servers) do
      --   config.capabilities = require('blink.cmp').get_lsp_capabilities(config.capabilities)
      --   lspconfig[server].setup(config)
      -- end

      lspconfig.clangd.setup({})

      lspconfig.ts_ls.setup({
        init_options = {
          plugins = {
            {
              name = "@vue/typescript-plugin",
              location = "/usr/lib/node_modules/@vue/language-server",
              languages = { "vue", "javascript", "typescript" }
            }
          },
          filetypes = { "vue", "typescript", "javascript", "javascriptreact", "typescriptreact" }
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/codeLens", { bufnr = bufnr }) then
            vim.lsp.codelens.refresh()
            vim.api.nvim_create_autocmd({ "BufEnter", "InsertLeave" }, {
              buffer = bufnr,
              callback = function()
                vim.lsp.codelens.refresh()
              end,
            })
          end
        end,
        filetypes = { "vue", "typescript", "javascript", "javascriptreact", "typescriptreact" },
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
      })
      lspconfig.volar.setup({
        -- capabilities = capabilities,
        filetypes = { 'vue' },
        -- 'typescript', 'javascript', 'javascriptreact', 'typescriptreact',
        init_options = {
          vue = {
            hybridMode = false,
          },
          typescript = {
            tsdk =
            "/home/luoqing/.local/share/nvim/mason/packages/vue-language-server/node_modules/typescript/lib/"
          },
        },
      })
      lspconfig.cssls.setup({})
      lspconfig.html.setup({})
      lspconfig.texlab.setup({})
      lspconfig.jsonls.setup({})
      lspconfig.clangd.setup({})
      lspconfig.lua_ls.setup({
        diagnostics = {
          underline = true,
          update_in_insert = false,
          virtual_text = true,

          --   spacing = 4,
          --   source = "if_many",
          --   prefix = "●",
          --   -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
          --   -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
          --   -- prefix = "icons",
          -- },
          severity_sort = true,
          signs = {
            text = {
              [vim.diagnostic.severity.ERROR] = "asdf ",
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
          lua_ls = {
            settings = {
              Lua = {
                diagnostics = {
                  enabled = true,
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
          }
        }
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
  {
    'nvimdev/lspsaga.nvim',
    lazy = true,
    config = function()
      require('lspsaga').setup({})
    end,
    dependencies = {
      'nvim-treesitter/nvim-treesitter', -- optional
      'nvim-tree/nvim-web-devicons',     -- optional
    }
  }
}
