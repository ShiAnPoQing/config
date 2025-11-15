return {
  "BrokenSunny/eye-track.nvim",
  keys = {
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
          label_position = "0",
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
          label_position = "0",
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
            return context.word_inner
          end,
          label_position = "0",
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
          label_position = "0",
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
          local jump
          require("eye-track.plugins.line")({
            matched = function(ctx)
              local offset = ctx.data.offset
              jump = offset > 0 and "k" or "j"
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
          require("eye-track.plugins.line")({
            matched = function(ctx)
              local row = ctx.data.row
              local col = ctx.data.col
              vim.api.nvim_win_set_cursor(0, { row, col })
            end,
          })
        end,
        { "n", "x" },
      },
    },
    ["0O"] = {
      function()
        require("eye-track.plugins.word")({
          keyword = function(context)
            return context.WORD_inner
          end,
          label_position = "1",
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
          label_position = "1",
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
          label_position = "-1",
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
          label_position = "-1",
          matched = function(ctx)
            vim.api.nvim_win_set_cursor(0, { ctx.line + 1, ctx.data.start_col })
          end,
        })
      end,
      { "n", "x", "o" },
    },
  },
  config = function(opt)
    require("eye-track").setup({})
  end,
}
