return {
  "BrokenSunny/eye-track.nvim",
  key = {
    ["0/"] = {
      function()
        local last_search = vim.fn.getreg("/")
        require("eye-track.plugins.word")({
          label = {
            position = 0,
          },
          matched = function(ctx)
            vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.start_col })
          end,
          keyword = last_search,
          hl_group = "Visual",
        })
      end,
      "n",
    },
    ["0#"] = {
      {
        function()
          local cword = vim.fn.expand("<cword>")
          require("eye-track.plugins.word")({
            label = {
              position = 0,
            },
            matched = function(ctx)
              vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.start_col })
            end,
            keyword = cword,
            hl_group = "Visual",
          })
        end,
        "n",
      },
      {
        function()
          vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
          local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
          local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
          local cword = vim.api.nvim_buf_get_text(0, start_row - 1, start_col, end_row - 1, end_col + 1, {})[1]
          require("eye-track.plugins.word")({
            label = {
              position = 0,
            },
            matched = function(ctx)
              vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.start_col })
              vim.api.nvim_feedkeys("v", "nx", false)
              vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.end_col - 1 })
            end,
            keyword = cword,
            hl_group = "Visual",
          })
        end,
        "x",
      },
    },
    ["0<C-M-l>"] = {
      function()
        local cursor = vim.api.nvim_win_get_cursor(0)
        require("eye-track.plugins.word")({
          condition = function(matches)
            for _, line_matches in ipairs(matches) do
              for _, match in ipairs(line_matches) do
                if match.row == cursor[1] and cursor[2] >= match.start_col and cursor[2] < match.end_col then
                  return true
                end
              end
            end
            return false
          end,
          label = {
            position = 0,
          },
          matched = function() end,
          keyword = function(context)
            return context.word_inner
          end,
          hl_group = function(match)
            if match.row == cursor[1] and cursor[2] >= match.start_col and cursor[2] < match.end_col then
              return "ErrorMsg"
            end
            return "Visual"
          end,
        })
      end,
      "n",
    },
    ["0<C-up>"] = {
      function()
        require("eye-track.plugins.line")({
          matched = function(ctx)
            require("move-line").move_line(ctx.data.offset)
          end,
        })
      end,
      { "n", "x" },
      depend = "move-line",
    },
    ["0<C-down>"] = {
      function()
        require("eye-track.plugins.line")({
          matched = function(ctx)
            require("move-line").move_line(ctx.data.offset)
          end,
        })
      end,
      { "n", "x" },
      depend = "move-line",
    },
    ["0V"] = {
      function()
        local cursor = vim.api.nvim_win_get_cursor(0)
        require("eye-track.plugins.line")({
          matched = function(ctx)
            local line = vim.api.nvim_buf_get_lines(0, ctx.data.row - 1, ctx.data.row, false)[1]
            local col = cursor[2]
            if cursor[2] > #line then
              col = #line
            end
            vim.api.nvim_win_set_cursor(0, { ctx.data.row, col })
            vim.api.nvim_feedkeys("V", "n", false)
          end,
        })
      end,
      "n",
    },
    ["0B"] = {
      function()
        require("eye-track.plugins.line")({
          matched = function(ctx)
            vim.api.nvim_win_set_cursor(0, { ctx.data.row, 1 })
            vim.api.nvim_feedkeys("O", "n", false)
          end,
        })
      end,
      "n",
    },
    ["0b"] = {
      function()
        require("eye-track.plugins.line")({
          matched = function(ctx)
            vim.api.nvim_win_set_cursor(0, { ctx.data.row, 1 })
            vim.api.nvim_feedkeys("o", "n", false)
          end,
        })
      end,
      "n",
    },
    ["0S"] = {
      function()
        require("eye-track.plugins.search")({
          matched = function(ctx)
            vim.api.nvim_buf_set_mark(0, "<", ctx.line + 1, ctx.data.start_col, {})
            vim.api.nvim_buf_set_mark(0, ">", ctx.line + 1, ctx.data.end_col, {})
            vim.api.nvim_feedkeys("gv", "nx", false)
          end,
        })
      end,
      { "x", "o" },
    },
    ["0s"] = {
      function()
        require("eye-track.plugins.search")({
          matched = function(ctx)
            vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.start_col })
          end,
        })
      end,
      { "n", "x", "o" },
    },
    ["0<space><space>l"] = {
      function()
        require("eye-track.plugins.line-start-end")({
          position = 2,
          matched = function(ctx)
            vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.col })
          end,
        })
      end,
      "n",
    },
    ["0<space>l"] = {
      function()
        require("eye-track.plugins.line-start-end")({
          position = 1,
          matched = function(ctx)
            vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.col })
          end,
        })
      end,
      "n",
    },
    ["0<space><space>h"] = {
      function()
        require("eye-track.plugins.line-start-end")({
          position = -2,
          matched = function(ctx)
            vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.col })
          end,
        })
      end,
      "n",
    },
    ["0<space>h"] = {
      function()
        require("eye-track.plugins.line-start-end")({
          position = -1,
          matched = function(ctx)
            vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.col })
          end,
        })
      end,
      "n",
    },
    ["0wW"] = {
      function()
        require("eye-track.plugins.word")({
          keyword = function(context)
            return context.WORD_outer
          end,
          label = {
            position = 0,
          },
          hl_group = "Visual",
          matched = function(ctx)
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
            vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.start_col })
            vim.api.nvim_feedkeys("v", "nx", false)
            vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.end_col - 1 })
          end,
        })
      end,
      { "x", "o" },
    },
    ["0ww"] = {
      function()
        require("eye-track.plugins.word")({
          keyword = function(context)
            return context.word_outer
          end,
          label = { position = 0 },
          hl_group = "Visual",
          matched = function(ctx)
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
            vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.start_col })
            vim.api.nvim_feedkeys("v", "nx", false)
            vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.end_col - 1 })
          end,
        })
      end,
      { "x", "o" },
    },
    ["0eW"] = {
      function()
        require("eye-track.plugins.word")({
          keyword = function(context)
            return context.WORD_inner
          end,
          label = { position = 0 },
          hl_group = "Visual",
          matched = function(ctx)
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
            vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.start_col })
            vim.api.nvim_feedkeys("v", "nx", false)
            vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.end_col - 1 })
          end,
        })
      end,
      { "x", "o" },
    },
    ["0ew"] = {
      function()
        require("eye-track.plugins.word")({
          keyword = function(context)
            return context.word_inner
          end,
          label = { position = 0 },
          hl_group = "Visual",
          matched = function(ctx)
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
            vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.start_col })
            vim.api.nvim_feedkeys("v", "nx", false)
            vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.end_col - 1 })
          end,
        })
      end,
      { "x", "o" },
    },
    ["0el"] = {
      function()
        require("eye-track.plugins.word")({
          keyword = function()
            return "^\\s*\\zs\\S.*\\S\\ze\\s*$"
          end,
          label = { position = 0 },
          hl_group = "Visual",
          matched = function(ctx)
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
            vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.start_col })
            vim.api.nvim_feedkeys("v", "nx", false)
            vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.end_col - 1 })
          end,
        })
      end,
      { "x", "o" },
    },
    ["0wl"] = {
      function()
        require("eye-track.plugins.word")({
          keyword = function()
            return "^\\zs\\s*\\S.*\\S\\ze\\s*$"
          end,
          label = { position = 0 },
          hl_group = "Visual",
          matched = function(ctx)
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
            vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.start_col })
            vim.api.nvim_feedkeys("v", "nx", false)
            vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.end_col - 1 })
          end,
        })
      end,
      { "x", "o" },
    },
    ["0dd"] = {
      function()
        require("eye-track.plugins.line")({
          matched = function(ctx)
            vim.api.nvim_buf_set_lines(0, ctx.data.row - 1, ctx.data.row, false, {})
          end,
        })
      end,
      "n",
    },
    ["0yy"] = {
      function()
        require("eye-track.plugins.line")({
          matched = function(ctx)
            local cursor = vim.api.nvim_win_get_cursor(0)
            vim.api.nvim_win_set_cursor(0, { ctx.data.row, cursor[2] })
            vim.api.nvim_feedkeys("yy", "nx", false)
            vim.api.nvim_win_set_cursor(0, cursor)
          end,
        })
      end,
      "n",
    },
    ["0cc"] = {
      function()
        require("eye-track.plugins.line")({
          matched = function(ctx)
            local cursor = vim.api.nvim_win_get_cursor(0)
            vim.api.nvim_win_set_cursor(0, { ctx.data.row, cursor[2] })
            vim.api.nvim_feedkeys("cc", "n", false)
          end,
        })
      end,
      "n",
    },
    ["0C"] = {
      function()
        require("eye-track.plugins.line")({
          matched = function(ctx)
            local cursor = vim.api.nvim_win_get_cursor(0)
            vim.api.nvim_win_set_cursor(0, { ctx.data.row, cursor[2] })
            vim.api.nvim_feedkeys("C", "n", false)
          end,
        })
      end,
      "n",
    },
    ["0Y"] = {
      function()
        local cursor = vim.api.nvim_win_get_cursor(0)
        require("eye-track.plugins.line")({
          matched = function(ctx)
            vim.api.nvim_win_set_cursor(0, { ctx.data.row, 1 })
            vim.api.nvim_feedkeys("Y", "nx", false)
            vim.api.nvim_win_set_cursor(0, cursor)
          end,
        })
      end,
      "n",
    },
    ["0k"] = {
      {
        function()
          local row = vim.fn.line(".")
          local jump
          require("eye-track.plugins.line")({
            range = function(ctx)
              return { ctx.topline, row }
            end,
            matched = function(ctx)
              local offset = ctx.data.offset
              jump = math.abs(offset) .. "k"
            end,
          })
          return jump
        end,
        "o",
        expr = true,
      },
      {
        function()
          local row = vim.fn.line(".")
          local jump
          require("eye-track.plugins.line")({
            range = function(ctx)
              return { ctx.topline, row }
            end,
            matched = function(ctx)
              local offset = ctx.data.offset
              jump = math.abs(offset) .. "k"
            end,
          })
          return jump
        end,
        { "n", "x" },
        expr = true,
      },
    },
    ["0j"] = {
      {
        function()
          local row = vim.fn.line(".")
          local jump
          require("eye-track.plugins.line")({
            range = function(ctx)
              return { row, ctx.botline }
            end,
            matched = function(ctx)
              local offset = ctx.data.offset
              jump = math.abs(offset) .. "j"
            end,
          })
          return jump
        end,
        "o",
        expr = true,
      },
      {
        function()
          local row = vim.fn.line(".")
          local jump
          require("eye-track.plugins.line")({
            range = function(ctx)
              return { row, ctx.botline }
            end,
            matched = function(ctx)
              local offset = ctx.data.offset
              jump = math.abs(offset) .. "j"
            end,
          })
          return jump
        end,
        { "n", "x" },
        expr = true,
      },
    },
    ["0m"] = {
      {
        function()
          local jump
          require("eye-track.plugins.line")({
            matched = function(ctx)
              local offset = ctx.data.offset
              jump = offset < 0 and "k" or "j"
              jump = math.abs(offset) .. jump
            end,
          })
          return jump
        end,
        "o",
        expr = true,
      },
      {
        function()
          local jump
          require("eye-track.plugins.line")({
            matched = function(ctx)
              local offset = ctx.data.offset
              jump = offset < 0 and "k" or "j"
              jump = math.abs(offset) .. jump
            end,
          })
          return jump
        end,
        { "n", "x" },
        expr = true,
      },
    },
    ["0O"] = {
      function()
        require("eye-track.plugins.word")({
          keyword = function(context)
            return context.WORD_inner
          end,
          label = { position = 1 },
          matched = function(ctx)
            vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.end_col - 1 })
          end,
        })
      end,
      { "n", "x", "o" },
    },
    ["0o"] = {
      function()
        require("eye-track.plugins.word")({
          keyword = function(context)
            return context.word_inner
          end,
          label = { position = 1 },
          matched = function(ctx)
            local mode = vim.api.nvim_get_mode().mode
            local row = ctx.line + 1
            local col = ctx.data.end_col - 1
            if mode == "no" then
              col = col + 1
            end
            vim.api.nvim_set_current_win(ctx.data.win)
            vim.api.nvim_win_set_cursor(ctx.data.win, { row, col })
          end,
        })
      end,
      { "n", "x", "o" },
    },
    ["0i"] = {
      function()
        require("eye-track.plugins.word")({
          keyword = function(context)
            return context.word_inner
          end,
          label = { position = -1 },
          matched = function(ctx)
            vim.api.nvim_set_current_win(ctx.data.win)
            vim.api.nvim_win_set_cursor(ctx.data.win, { ctx.line + 1, ctx.data.start_col })
          end,
        })
      end,
      { "n", "x", "o" },
    },
    ["0I"] = {
      function()
        require("eye-track.plugins.word")({
          keyword = function(context)
            return context.WORD_inner
          end,
          label = { position = -1 },
          matched = function(ctx)
            vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.start_col })
          end,
        })
      end,
      { "n", "x", "o" },
    },
    -- ["0sn"] = {
    --   function()
    --     local cursor = vim.api.nvim_win_get_cursor(0)
    --     require("eye-track.plugins.line")({
    --       matched = function(ctx)
    --         local row = ctx.data.topline - ctx.data.offset
    --         row = row <= 0 and 1 or row
    --         vim.cmd("keepjumps normal! " .. row .. "zt")
    --       end,
    --     })
    --     vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] })
    --   end,
    --   { "n", "x" },
    -- },
  },
  config = function()
    require("eye-track").setup({})
  end,
}

-- return {
--   "BrokenSunny/eye-track.nvim",
--   keys = {
--     ["0S"] = {
--       function()
--         require("eye-track.plugins.search")({
--           matched = function(ctx)
--             vim.api.nvim_buf_set_mark(0, "<", ctx.line + 1, ctx.data.start_col, {})
--             vim.api.nvim_buf_set_mark(0, ">", ctx.line + 1, ctx.data.end_col, {})
--             vim.api.nvim_feedkeys("gv", "nx", false)
--           end,
--         })
--       end,
--       { "x", "o" },
--     },
--     ["0s"] = {
--       function()
--         require("eye-track.plugins.search")({
--           matched = function(ctx)
--             vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.start_col })
--           end,
--         })
--       end,
--       { "n", "x", "o" },
--     },
--     ["0<space><space>l"] = {
--       function()
--         require("eye-track.plugins.line-start-end")({
--           position = 2,
--           matched = function(ctx)
--             vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.col })
--           end,
--         })
--       end,
--       "n",
--     },
--     ["0<space>l"] = {
--       function()
--         require("eye-track.plugins.line-start-end")({
--           position = 1,
--           matched = function(ctx)
--             vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.col })
--           end,
--         })
--       end,
--       "n",
--     },
--     ["0<space><space>h"] = {
--       function()
--         require("eye-track.plugins.line-start-end")({
--           position = -2,
--           matched = function(ctx)
--             vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.col })
--           end,
--         })
--       end,
--       "n",
--     },
--     ["0<space>h"] = {
--       function()
--         require("eye-track.plugins.line-start-end")({
--           position = -1,
--           matched = function(ctx)
--             vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.col })
--           end,
--         })
--       end,
--       "n",
--     },
--     ["0wW"] = {
--       function()
--         require("eye-track.plugins.word")({
--           keyword = function(context)
--             return context.WORD_outer
--           end,
--           label_position = "0",
--           hl_group = "Visual",
--           matched = function(ctx)
--             vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
--             vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.start_col })
--             vim.api.nvim_feedkeys("v", "nx", false)
--             vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.end_col - 1 })
--           end,
--         })
--       end,
--       { "x", "o" },
--     },
--     ["0ww"] = {
--       function()
--         require("eye-track.plugins.word")({
--           keyword = function(context)
--             return context.word_outer
--           end,
--           label_position = "0",
--           hl_group = "Visual",
--           matched = function(ctx)
--             vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
--             vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.start_col })
--             vim.api.nvim_feedkeys("v", "nx", false)
--             vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.end_col - 1 })
--           end,
--         })
--       end,
--       { "x", "o" },
--     },
--     ["0eW"] = {
--       function()
--         require("eye-track.plugins.word")({
--           keyword = function(context)
--             return context.word_inner
--           end,
--           label_position = "0",
--           hl_group = "Visual",
--           matched = function(ctx)
--             vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
--             vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.start_col })
--             vim.api.nvim_feedkeys("v", "nx", false)
--             vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.end_col - 1 })
--           end,
--         })
--       end,
--       { "x", "o" },
--     },
--     ["0ew"] = {
--       function()
--         require("eye-track.plugins.word")({
--           keyword = function(context)
--             return context.word_inner
--           end,
--           label_position = "0",
--           hl_group = "Visual",
--           matched = function(ctx)
--             vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
--             vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.start_col })
--             vim.api.nvim_feedkeys("v", "nx", false)
--             vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.end_col - 1 })
--           end,
--         })
--       end,
--       { "x", "o" },
--     },
--     ["0dd"] = {
--       function()
--         require("eye-track.plugins.line")({
--           matched = function(ctx)
--             vim.api.nvim_buf_set_lines(0, ctx.data.row - 1, ctx.data.row, false, {})
--           end,
--         })
--       end,
--       "n",
--     },
--     ["0yy"] = {
--       function()
--         require("eye-track.plugins.line")({
--           matched = function(ctx)
--             local cursor = vim.api.nvim_win_get_cursor(0)
--             vim.api.nvim_win_set_cursor(0, { ctx.data.row, cursor[2] })
--             vim.api.nvim_feedkeys("yy", "nx", false)
--             vim.api.nvim_win_set_cursor(0, cursor)
--           end,
--         })
--       end,
--       "n",
--     },
--     ["0cc"] = {
--       function()
--         require("eye-track.plugins.line")({
--           matched = function(ctx)
--             local cursor = vim.api.nvim_win_get_cursor(0)
--             vim.api.nvim_win_set_cursor(0, { ctx.data.row, cursor[2] })
--             vim.api.nvim_feedkeys("cc", "n", false)
--           end,
--         })
--       end,
--       "n",
--     },
--     ["0C"] = {
--       function()
--         require("eye-track.plugins.line")({
--           matched = function(ctx)
--             local cursor = vim.api.nvim_win_get_cursor(0)
--             vim.api.nvim_win_set_cursor(0, { ctx.data.row, cursor[2] })
--             vim.api.nvim_feedkeys("C", "n", false)
--           end,
--         })
--       end,
--       "n",
--     },
--     ["nk"] = {
--       {
--         function()
--           local jump
--           require("eye-track.plugins.line")({
--             matched = function(ctx)
--               local offset = ctx.data.offset
--               jump = offset > 0 and "k" or "j"
--               jump = math.abs(offset) .. jump
--             end,
--           })
--           return jump
--         end,
--         "o",
--         expr = true,
--       },
--       {
--         function()
--           require("eye-track.plugins.line")({
--             matched = function(ctx)
--               local row = ctx.data.row
--               local col = ctx.data.col
--               vim.api.nvim_win_set_cursor(0, { row, col })
--             end,
--           })
--         end,
--         { "n", "x" },
--       },
--     },
--     ["0O"] = {
--       function()
--         require("eye-track.plugins.word")({
--           keyword = function(context)
--             return context.WORD_inner
--           end,
--           label_position = "1",
--           matched = function(ctx)
--             vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.end_col - 1 })
--           end,
--         })
--       end,
--       { "n", "x", "o" },
--     },
--     ["0o"] = {
--       function()
--         require("eye-track.plugins.word")({
--           keyword = function(context)
--             return context.word_inner
--           end,
--           label_position = "1",
--           matched = function(ctx)
--             local mode = vim.api.nvim_get_mode().mode
--             local row = ctx.line + 1
--             local col = ctx.data.end_col - 1
--             if mode == "no" then
--               col = col + 1
--             end
--             vim.api.nvim_set_current_win(ctx.data.win)
--             vim.api.nvim_win_set_cursor(ctx.data.win, { row, col })
--           end,
--         })
--       end,
--       { "n", "x", "o" },
--     },
--     ["0i"] = {
--       function()
--         require("eye-track.plugins.word")({
--           keyword = function(context)
--             return context.word_inner
--           end,
--           label_position = "-1",
--           matched = function(ctx)
--             vim.api.nvim_set_current_win(ctx.data.win)
--             vim.api.nvim_win_set_cursor(ctx.data.win, { ctx.line + 1, ctx.data.start_col })
--           end,
--         })
--       end,
--       { "n", "x", "o" },
--     },
--     ["0I"] = {
--       function()
--         require("eye-track.plugins.word")({
--           keyword = function(context)
--             return context.WORD_inner
--           end,
--           label_position = "-1",
--           matched = function(ctx)
--             vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.start_col })
--           end,
--         })
--       end,
--       { "n", "x", "o" },
--     },
--   },
--   config = function(opt)
--     require("eye-track").setup({})
--   end,
-- }
