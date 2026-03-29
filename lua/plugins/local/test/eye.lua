return {
  name = "eye.nvim",
  key = {
    ["0k"] = {
      {
        function()
          local row = vim.fn.line(".")
          local jump
          require("eye.plugin.line").gaze({
            range = function(ctx)
              return { ctx.topline, row }
            end,
            matched = function(ctx)
              -- local offset = ctx.offset
              -- jump = math.abs(offset) .. "k"
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
          require("eye.plugin.line").gaze({
            range = function(ctx)
              return { ctx.topline, row }
            end,
            matched = function(ctx)
              vim.print(ctx)
              -- local offset = ctx.offset
              -- jump = math.abs(offset) .. "k"
            end,
          })
          return jump
        end,
        { "n", "x" },
        expr = true,
      },
    },
    -- ["0j"] = {
    --   {
    --     function()
    --       local row = vim.fn.line(".")
    --       local jump
    --       require("eye.plugin.line")({
    --         range = function(ctx)
    --           return { row, ctx.botline }
    --         end,
    --         matched = function(ctx)
    --           local offset = ctx.offset
    --           jump = math.abs(offset) .. "j"
    --         end,
    --       })
    --       return jump
    --     end,
    --     "o",
    --     expr = true,
    --   },
    --   {
    --     function()
    --       local row = vim.fn.line(".")
    --       local jump
    --       require("eye.plugin.line")({
    --         range = function(ctx)
    --           return { row, ctx.botline }
    --         end,
    --         matched = function(ctx)
    --           local offset = ctx.offset
    --           jump = math.abs(offset) .. "j"
    --         end,
    --       })
    --       return jump
    --     end,
    --     { "n", "x" },
    --     expr = true,
    --   },
    -- },
    -- ["0m"] = {
    --   {
    --     function()
    --       local jump
    --       require("eye.plugin.line")({
    --         matched = function(ctx)
    --           local offset = ctx.offset
    --           jump = offset < 0 and "k" or "j"
    --           jump = math.abs(offset) .. jump
    --         end,
    --       })
    --       return jump
    --     end,
    --     "o",
    --     expr = true,
    --   },
    --   {
    --     function()
    --       local jump
    --       require("eye.plugin.line")({
    --         matched = function(ctx)
    --           local offset = ctx.offset
    --           jump = offset < 0 and "k" or "j"
    --           jump = math.abs(offset) .. jump
    --         end,
    --       })
    --       return jump
    --     end,
    --     { "n", "x" },
    --     expr = true,
    --   },
    -- },
    ["<leader>-"] = {
      function()
        require("eye.plugin.word").gaze({
          regex = function(builtin)
            return "\\k"
          end,
          position = 1,
          matched = function(ctx)
            local item = ctx.items[1]
            local row = item.row
            local col = item.col
            vim.api.nvim_win_set_cursor(0, { row + 1, col })
          end,
        })
      end,
      "n",
    },
    ["<leader><leader>-"] = {
      function()
        require("eye.plugin.search").gaze({
          matched = function(ctx)
            vim.api.nvim_win_set_cursor(0, { ctx.data.row, ctx.data.start_col })
          end,
        })
      end,
      "n",
    },
    ["<leader><leader><leader>-"] = {
      function()
        require("eye.plugin.line").gaze({
          matched = function(ctx)
            local item = ctx.items[1]
            local row = item.row
            local col = item.col
            vim.api.nvim_win_set_cursor(0, { row + 1, col })
          end,
        })
      end,
      "n",
    },
  },
  config = function()
    require("eye").setup()
  end,
}
