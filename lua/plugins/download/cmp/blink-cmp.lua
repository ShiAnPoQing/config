local function in_snippet_snippet_forward(cmp)
  local luasnip = require("luasnip")
  if luasnip.in_snippet() then
    return cmp.snippet_forward()
  end
end

local function is_lsp_snippet_selected(cmp)
  local selected_item = cmp.get_selected_item()
  return selected_item and selected_item.source_id == "lsp" and selected_item.kind == 15
end

return {
  {
    "saghen/blink.lib",
    lazy = true,
  },
  {
    "saghen/blink.cmp",
    depend = { "saghen/blink.lib", "L3MON4D3/LuaSnip", "folke/lazydev.nvim" },
    run = function()
      vim.schedule(function()
        ---@diagnostic disable-next-line: undefined-field
        require("blink.cmp").build():pwait()
      end)
    end,
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
      local cmp = require("blink-cmp")
      local idx_icons = { "¹", "²", "³", "⁴", "⁵", "⁶", "⁷", "⁸", "⁹", "⁰" }

      cmp.setup({
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        appearance = {
          nerd_font_variant = "mono",
          kind_icons = {
            -- Text = "󰦨",
            Method = "",
            Function = "󰡱",
            Constructor = "",
            Field = "󰜢",
            Variable = "󰆦",
            Property = "󰜢",
            Class = "󰠱",
            Interface = "",
            Struct = "󰙅",
            Module = "",
            --
            -- Unit = "󰑭",
            -- Value = "󰎠",
            -- Enum = "",
            -- EnumMember = "",
            Keyword = "",
            Constant = "󰏿",
            Snippet = "󱃖",
            Color = "󰏘",
            File = "󰈙",
            -- Reference = "󰈇",
            -- Folder = "󰉋",
            -- Event = "",
            Operator = "󰆕",
            TypeParameter = "󰬛",
          },
        },
        completion = {
          documentation = { auto_show = true, auto_show_delay_ms = 100, window = { border = "single" } },
          menu = {
            scrollbar = false,
            max_height = 10,
            draw = {
              gap = 0,
              align_to = "label",
              snippet_indicator = "󱑽",
              padding = { 0, 0 },
              columns = {
                { "kind_icon", "left_block" },
                { "label", "source_name", gap = 1 },
                { "right_black" },
              },
              components = {
                right_black = {
                  ellipsis = false,
                  text = function()
                    return "▐"
                  end,
                  highlight = function(ctx)
                    local idx = cmp.get_selected_item_idx()
                    if ctx.idx == idx then
                      return { { group = ctx.kind_hl .. "Block", priority = 20000 } }
                    end
                    return { { group = "BlinkCmpMenuBackground" } }
                  end,
                },
                test = {
                  ellipsis = false,
                  text = function(ctx)
                    local idx_icon = idx_icons[ctx.idx] or ""
                    return idx_icon
                  end,
                  highlight = function(ctx)
                    return { { group = ctx.kind_hl .. "Block", priority = 20000 } }
                  end,
                },
                left_block = {
                  ellipsis = false,
                  text = function()
                    return "▌"
                  end,
                  highlight = function(ctx)
                    return { { group = ctx.kind_hl .. "Block", priority = 20000 } }
                  end,
                },
                kind_icon = {
                  ellipsis = false,
                  text = function(ctx)
                    return " " .. ctx.kind_icon .. " "
                  end,
                  highlight = function(ctx)
                    return { { group = ctx.kind_hl, priority = 20000 } }
                  end,
                },
                source_name = {
                  width = { max = 30 },
                  text = function(ctx)
                    return ctx.source_name
                  end,
                  highlight = function(ctx)
                    local idx = cmp.get_selected_item_idx()
                    if ctx.idx == idx then
                      return { { group = ctx.kind_hl .. "Source", priority = 20000 } }
                    end
                    return { { group = "BlinkCmpSource", priority = 20000 } }
                  end,
                },
              },
            },
            cmdline_position = function()
              if vim.g.ui_cmdline_pos ~= nil then
                local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
                return { pos[1] - 1, pos[2] }
              end
              local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
              return { vim.o.lines - height, 0 }
            end,
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
                if not cmp.is_menu_visible() then
                  cmp.show()
                end
                return cmp.select_and_accept()
              end,
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
          },
          providers = {
            cmdline = {
              -- min_keyword_length = function(ctx)
              --   --- 手动激活
              --   if ctx.trigger.initial_kind == "manual" then
              --     return 0
              --   end
              --   if ctx.mode == "cmdline" and string.find(ctx.line, " ") == nil then
              --     return 3
              --   end
              --   return 0
              -- end,
            },
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
              if cmp.is_menu_visible() then
                return cmp.select_next()
              else
                return cmp.show()
              end
            end,
            "fallback",
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
          --- 补全方案：
          ---        preselect = false,
          ---        auto_insert = true,
          --- <Tab>:
          ---       1. menu show -> expand snippet -> in snippet and snippet forward -> select_and_accept -> fallback
          ---       2. menu hide -> in snippet and snippet forward -> expand snippet -> select_and_accept -> fallback
          --- Limitation：
          ---         1. snippet jumpable and snippet expandable and menu hide:
          ---             <Tab> can't expand: use <C-n>/<C-e> to show menu, then use <Tab> to expand snippet
          ---         1. snippet jumpable and snippet expandable and menu show:
          ---             <Tab> can't select and accept: use <C-n> to select, then use <CR> to accept
          ["<Tab>"] = {
            function(cmp)
              local luasnip = require("luasnip")
              if cmp.is_menu_visible() then
                return luasnip.expand()
              else
                --- Only in snippet, snippet forward
                return in_snippet_snippet_forward(cmp)
              end
            end,
            function(cmp)
              local luasnip = require("luasnip")
              if cmp.is_menu_visible() then
                --- If seleted item is lsp snippet, select and accept
                if not is_lsp_snippet_selected(cmp) then
                  --- Only in snippet, snippet forward
                  return in_snippet_snippet_forward(cmp)
                end
              else
                return luasnip.expand()
              end
            end,
            "select_and_accept",
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
                return cmp.select_and_accept({ index = 1 })
              end
            end,
            "fallback_to_mappings",
          },
          ["<C-2>"] = {
            function(cmp)
              if cmp.is_menu_visible() then
                return cmp.select_and_accept({ index = 1 })
              end
            end,
            "fallback_to_mappings",
          },
          ["<C-3>"] = {
            function(cmp)
              if cmp.is_menu_visible() then
                return cmp.select_and_accept({ index = 1 })
              end
            end,
            "fallback_to_mappings",
          },
          ["<C-4>"] = {
            function(cmp)
              if cmp.is_menu_visible() then
                return cmp.select_and_accept({ index = 1 })
              end
            end,
            "fallback_to_mappings",
          },
          ["<C-5>"] = {
            function(cmp)
              if cmp.is_menu_visible() then
                return cmp.select_and_accept({ index = 1 })
              end
            end,
            "fallback_to_mappings",
          },
          ["<C-6>"] = {
            function(cmp)
              if cmp.is_menu_visible() then
                return cmp.select_and_accept({ index = 1 })
              end
            end,
            "fallback_to_mappings",
          },
          ["<C-7>"] = {
            function(cmp)
              if cmp.is_menu_visible() then
                return cmp.select_and_accept({ index = 1 })
              end
            end,
            "fallback_to_mappings",
          },
          ["<C-8>"] = {
            function(cmp)
              if cmp.is_menu_visible() then
                return cmp.select_and_accept({ index = 1 })
              end
            end,
            "fallback_to_mappings",
          },
          ["<C-9>"] = {
            function(cmp)
              if cmp.is_menu_visible() then
                return cmp.select_and_accept({ index = 1 })
              end
            end,
            "fallback_to_mappings",
          },
          ["<C-0>"] = {
            function(cmp)
              if cmp.is_menu_visible() then
                return cmp.select_and_accept({ index = 1 })
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
