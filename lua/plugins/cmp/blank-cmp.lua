return {
  "saghen/blink.cmp",
  dependencies = {
    -- 'rafamadriz/friendly-snippets',
    -- { 'L3MON4D3/LuaSnip', version = 'v2.*' },
  },
  build = "cargo +nightly build --release",

  event = { "InsertEnter", "CmdlineEnter" },
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    appearance = {
      nerd_font_variant = "mono",
    },
    completion = {
      documentation = { auto_show = true, auto_show_delay_ms = 500 },
      menu = {
        draw = {
          columns = { { "kind_icon" }, { "label" }, { "source_name" } },
        },
      },
      list = {
        selection = {
          preselect = false,
          auto_insert = true,
        },
      },
      ghost_text = {
        enabled = false,
        show_with_selection = true,
        show_without_selection = true,
        show_with_menu = true,
        show_without_menu = true,
      },
    },
    cmdline = {
      completion = {
        menu = {
          auto_show = true,
        },
        list = {
          selection = {
            preselect = false,
            auto_insert = true,
          },
        },
        ghost_text = { enabled = false },
      },
    },
    sources = {
      default = { "snippets", "lsp", "path", "buffer" },
    },
    fuzzy = { implementation = "prefer_rust_with_warning" },
    snippets = { preset = "luasnip" },
    signature = { enabled = true },
    keymap = {
      preset = "none",
      ["<C-c>"] = {
        function(cmp)
          if cmp.is_menu_visible() then
            cmp.cancel()
          else
            cmp.show()
          end
        end,
      },
      ["<C-n>"] = {
        function(cmp)
          if cmp.is_menu_visible() then
            cmp.select_next()
          else
            cmp.show()
          end
        end,
      },
      ["<C-p>"] = {
        function(cmp)
          if cmp.is_menu_visible() then
            cmp.select_prev()
          else
            cmp.show()
          end
        end,
      },
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = {
        "select_and_accept",
        "snippet_forward",
        "fallback",
      },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
    },
  },
  opts_extend = { "sources.default" },
  init = function()
    vim.api.nvim_set_hl(0, "BlinkCmpSource", {
      fg = "#50417D", -- 前景色
      bold = true, -- 粗体
    })
  end,
}
