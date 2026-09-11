return {
  {
    "saghen/blink.lib",
    lazy = true,
  },
  {
    "saghen/blink.cmp",
    depend = { "saghen/blink.lib", "L3MON4D3/LuaSnip" },
    run = function()
      vim.schedule(function()
        ---@diagnostic disable-next-line: undefined-field
        require("blink.cmp").build():pwait()
      end)
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
            max_height = 1000,
            -- border = "single",
            draw = {
              padding = 1,
              columns = {
                { "kind_icon", "label", gap = 1 },
                { "source_name" },
              },
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
          accept = { auto_brackets = { enabled = true } },
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
              function(cmp)
                if cmp.is_menu_visible() then
                  cmp.select_and_accept()
                  return true
                else
                  cmp.show()
                  cmp.select_and_accept()
                  return true
                end
              end,
              -- "select_and_accept",
              "fallback",
            },
          },
          completion = {
            menu = {
              max_height = 1000,
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
          per_filetype = {
            lua = {
              inherit_defaults = true,
              "lazydev",
            },
            -- snacks_input = {
            --   "path",
            -- },
            -- vim = { inherit_defaults = true, 'cmdline' },
          },
          providers = {
            snippets = {
              transform_items = function(_, items)
                for _, item in ipairs(items) do
                  if item.source_id == "snippets" then
                    item.insertText = item.label
                  end
                end
                return items
              end,
            },
            lazydev = {
              enabled = true,
              name = "LazyDev",
              module = "lazydev.integrations.blink",
              score_offset = 100,
            },
            cmdline = {
              min_keyword_length = function(ctx)
                -- when typing a command, only show when the keyword is 3 characters or longer
                if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
                  return 2
                end
                return 0
              end,
            },
          },
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
              -- local luasnip = require("luasnip")
              -- if luasnip.choice_active() and luasnip.in_snippet() then
              --   vim.schedule(function()
              --     luasnip.change_choice(1)
              --   end)
              --   return
              -- end
              if cmp.is_menu_visible() then
                cmp.select_next()
              else
                cmp.show()
              end
            end,
          },
          ["<C-p>"] = {
            function(cmp)
              -- local luasnip = require("luasnip")
              -- if luasnip.choice_active() and luasnip.in_snippet() then
              --   vim.schedule(function()
              --     luasnip.change_choice(-1)
              --   end)
              --   return
              -- end
              if cmp.is_menu_visible() then
                cmp.select_prev()
              else
                cmp.show()
              end
            end,
          },
          ["<CR>"] = {
            --- 使用 Luasnip API 触发 snippet，而非 blink-cmp 内置行为
            --- 示例 snippet 通过 clear_region 来修正 -- @version 的显示
            --- blink-cmp 内置行为导致 resolveExpandParams 失效
            --[[
            s({
              trig = "@version",
              show_condition = function(line_to_cursor)
                local from = line_to_cursor:find("%-*%s*")
                if not from then
                  return false
                end
                return true
              end,
              resolveExpandParams = function(snippet, line_to_cursor, matched_trigger, captures)
                local from = line_to_cursor:find("%-+%s*@version$")

                if not from then
                  return
                end

                -- from 是 Lua 1-based column
                return {
                  clear_region = {
                    from = {
                      vim.fn.line(".") - 1,
                      from - 1,
                    },
                    to = {
                      vim.fn.line(".") - 1,
                      #line_to_cursor,
                    },
                  },
                }
              end
            }, {
              t("--- @version "),
              i(1),
            }),
            --]]
            function()
              local luasnip = require("luasnip")
              local expandable = luasnip.expandable()
              if expandable then
                vim.schedule(function()
                  luasnip.expand()
                end)
                return true
              end
            end,
            "accept",
            "fallback",
          },
          --- 补全方案：
          ---        preselect = false,
          ---        auto_insert = true,
          --- <Tab> 用于在不预选 menu 中第一个 item 且不主动选择的情况下：
          ---        选中 menu 第一个 item，并接受该 item
          --- ISSUE: 如果 keyword 本身就是 snippet 的 trigger，但是 menu 第一个 item 却不是该 snippet
          ---        导致 snippet 没有触发，这里我选择 snippet 的优先级更高
          --- SOLUTION: "select_and_accept" 作为 snippet trigger 的 fallback
          ---           同时修复 snippet 处于 active 状态下，
          ---           <Tab> 用于 snippet jump 而不是 expand snippet 或 select_and_accept
          ["<Tab>"] = {
            function()
              local luasnip = require("luasnip")
              local expandable = luasnip.expandable()
              if expandable then
                vim.schedule(function()
                  luasnip.expand()
                end)
                return true
              end
              if luasnip.in_snippet() then
                vim.schedule(function()
                  luasnip.jump(1)
                end)
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
          ["<C-1>"] = {
            function(cmp)
              if cmp.is_menu_visible() then
                cmp.accept({ index = 1 })
                return true
              end
            end,
            "fallback_to_mappings",
          },
          ["<C-2>"] = {
            function(cmp)
              if cmp.is_menu_visible() then
                cmp.accept({ index = 1 })
                return true
              end
            end,
            "fallback_to_mappings",
          },
          ["<C-3>"] = {
            function(cmp)
              if cmp.is_menu_visible() then
                cmp.accept({ index = 1 })
                return true
              end
            end,
            "fallback_to_mappings",
          },
          ["<C-4>"] = {
            function(cmp)
              if cmp.is_menu_visible() then
                cmp.accept({ index = 1 })
                return true
              end
            end,
            "fallback_to_mappings",
          },
          ["<C-5>"] = {
            function(cmp)
              if cmp.is_menu_visible() then
                cmp.accept({ index = 1 })
                return true
              end
            end,
            "fallback_to_mappings",
          },
          ["<C-6>"] = {
            function(cmp)
              if cmp.is_menu_visible() then
                cmp.accept({ index = 1 })
                return true
              end
            end,
            "fallback_to_mappings",
          },
          ["<C-7>"] = {
            function(cmp)
              if cmp.is_menu_visible() then
                cmp.accept({ index = 1 })
                return true
              end
            end,
            "fallback_to_mappings",
          },
          ["<C-8>"] = {
            function(cmp)
              if cmp.is_menu_visible() then
                cmp.accept({ index = 1 })
                return true
              end
            end,
            "fallback_to_mappings",
          },
          ["<C-9>"] = {
            function(cmp)
              if cmp.is_menu_visible() then
                cmp.accept({ index = 1 })
                return true
              end
            end,
            "fallback_to_mappings",
          },
          ["<C-0>"] = {
            function(cmp)
              if cmp.is_menu_visible() then
                cmp.accept({ index = 1 })
                return true
              end
            end,
            "fallback_to_mappings",
          },
        },
        -- opts_extend = { "lesources.default" },
      })
      vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", {
        link = "PmenuKind",
      })
    end,
  },
}
