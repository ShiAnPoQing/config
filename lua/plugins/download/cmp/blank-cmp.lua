return {
  "saghen/blink.cmp",
  depend = {
    -- { 'L3MON4D3/LuaSnip', version = 'v2.*' },
  },
  run = function(plug)
    vim
      .system({ "cargo", "+nightly", "build", "--release" }, {
        cwd = plug.path,
        text = true,
      })
      :wait()
  end,
  event = { "InsertEnter", "CmdlineEnter" },
  config = function()
    require("blink-cmp").setup({
      ---@module 'blink.cmp'
      ---@type blink.cmp.Config
      appearance = {
        nerd_font_variant = "mono",
        kind_icons = {
          Text = "󰉿",
          Method = "󰆧",
          Function = "󰊕",
          Constructor = "",

          Field = "󰜢",
          Variable = "󰆦",
          Property = "󰜢",

          Class = "󰠱",
          Interface = "",
          Struct = "󰙅",
          Module = "",

          Unit = "󰑭",
          Value = "󰎠",
          Enum = "",
          EnumMember = "",

          Keyword = "󰌋",
          Constant = "󰏿",

          Snippet = "",
          Color = "󰏘",
          File = "󰈙",
          Reference = "󰈇",
          Folder = "󰉋",
          Event = "",
          Operator = "󰆕",
          TypeParameter = "󰬛",
        },
      },

      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 0 },
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
          ["<C-e>"] = {
            function(cmp)
              if cmp.is_menu_visible() then
                cmp.hide()
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
          ["<Tab>"] = {
            "select_and_accept",
            "fallback",
          },
        },
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
        ["<C-e>"] = {
          function(cmp)
            if cmp.is_menu_visible() then
              cmp.hide()
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
        -- 我选择 Snippet 优先级最高
        -- 即使 Snippet 没在 menu 中，
        -- 也会优先触发 Snippet，而不是选中 menu 第一项
        ["<Tab>"] = {
          function(cmp)
            local luasnip = require("luasnip")
            local expandable = luasnip.expandable()

            if expandable then
              vim.schedule(function()
                luasnip.expand()
              end)
              return true
            end

            if luasnip.in_snippet() then
              luasnip.jump(1)
              return true
            end
          end,
          "select_and_accept",
          "snippet_forward",
          "fallback",
        },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        ["<C-S-n>"] = { "scroll_documentation_up", "fallback" },
        ["<C-S-p>"] = { "scroll_documentation_down", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
      },
      -- opts_extend = { "sources.default" },
      -- init = function() end,
    })
  end,
}
