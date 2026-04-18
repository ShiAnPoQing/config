return {
  name = "eye.nvim",
  depend = "reasonable-scroll.nvim",
  lazy = false,
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
              jump = math.abs(ctx.data.row - row) .. "k"
            end,
          })
          return jump
        end,
        expr = true,
        "o",
      },
      {
        function()
          local row = vim.fn.line(".")
          require("eye.plugin.line").gaze({
            range = function(ctx)
              return { ctx.topline, row }
            end,
            matched = function(ctx)
              vim.api.nvim_win_set_cursor(0, { ctx.data.row, ctx.data.col })
            end,
          })
        end,
        { "n", "x" },
      },
    },
    ["0j"] = {
      {
        function()
          local row = vim.fn.line(".")
          local jump
          require("eye.plugin.line").gaze({
            range = function(ctx)
              return { row, ctx.botline }
            end,
            matched = function(ctx)
              jump = math.abs(ctx.data.row - row) .. "j"
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
          require("eye.plugin.line").gaze({
            range = function(ctx)
              return { row, ctx.botline }
            end,
            matched = function(ctx)
              vim.api.nvim_win_set_cursor(0, { ctx.data.row, ctx.data.col })
            end,
          })
        end,
        { "n", "x" },
      },
    },
    ["0m"] = {
      {
        function()
          local row = vim.fn.line(".")
          local jump
          require("eye.plugin.line").gaze({
            matched = function(ctx)
              local offset = ctx.data.row - row
              jump = math.abs(offset) .. (offset < 0 and "k" or "j")
            end,
          })
          return jump
        end,
        "o",
        expr = true,
      },
      {
        function()
          require("eye.plugin.line").gaze({
            matched = function(ctx)
              vim.api.nvim_win_set_cursor(0, { ctx.data.row, ctx.data.col })
            end,
          })
        end,
        { "n", "x" },
      },
    },
    ["0<C-k>"] = {
      function()
        local row = vim.fn.line(".")
        require("eye.plugin.line").gaze({
          range = function(range)
            return { range.topline, row }
          end,
          matched = function(ctx)
            require("reasonable-scroll").scroll_down(math.abs(ctx.data.offset))
          end,
        })
      end,
      { "n", "x" },
    },
    ["0<C-j>"] = {
      function()
        local row = vim.fn.line(".")
        require("eye.plugin.line").gaze({
          range = function(range)
            return { row, range.botline }
          end,
          matched = function(ctx)
            require("reasonable-scroll").scroll_up(math.abs(ctx.data.offset))
          end,
        })
      end,
      { "n", "x" },
    },
    ["0i"] = {
      function()
        require("eye.plugin.word").gaze({
          regex = function(ctx)
            return ctx["word.inner"]
          end,
          position = -1,
          matched = function(ctx)
            local row = ctx.data.row
            local col = ctx.data.start_col
            vim.api.nvim_win_set_cursor(0, { row, col })
          end,
        })
      end,
      { "n", "x", "o" },
    },
    ["0gd"] = {
      function()
        require("eye.plugin.word").gaze({
          regex = function(ctx)
            return ctx["word.inner"]
          end,
          position = 0,
          hl_group = "Visual",
          matched = function(ctx)
            local mode = vim.api.nvim_get_mode().mode
            local row = ctx.data.row
            local col = ctx.data.end_col - 1
            if mode == "no" then
              col = col + 1
            end
            vim.api.nvim_win_set_cursor(0, { row, col })
            vim.api.nvim_feedkeys("gd", "m", false)
          end,
        })
      end,
      "n",
    },
    ["0o"] = {
      function()
        require("eye.plugin.word").gaze({
          regex = function(ctx)
            return ctx["word.inner"]
          end,
          position = 1,
          matched = function(ctx)
            local mode = vim.api.nvim_get_mode().mode
            local row = ctx.data.row
            local col = ctx.data.end_col - 1
            if mode == "no" then
              col = col + 1
            end
            vim.api.nvim_win_set_cursor(0, { row, col })
          end,
        })
      end,
      { "n", "x", "o" },
    },
    ["0I"] = {
      function()
        require("eye.plugin.word").gaze({
          regex = function(ctx)
            return ctx["WORD.inner"]
          end,
          position = -1,
          matched = function(ctx)
            local row = ctx.data.row
            local col = ctx.data.start_col
            vim.api.nvim_win_set_cursor(0, { row, col })
          end,
        })
      end,
      { "n", "x", "o" },
    },
    ["0O"] = {
      function()
        require("eye.plugin.word").gaze({
          regex = function(ctx)
            return ctx["WORD.inner"]
          end,
          position = 1,
          matched = function(ctx)
            local mode = vim.api.nvim_get_mode().mode
            local row = ctx.data.row
            local col = ctx.data.end_col - 1
            if mode == "no" then
              col = col + 1
            end
            vim.api.nvim_win_set_cursor(0, { row + 1, col })
          end,
        })
      end,
      { "n", "x", "o" },
    },
    ["0f"] = {
      function()
        require("eye.plugin.search").gaze({
          matched = function(ctx)
            vim.api.nvim_win_set_cursor(0, { ctx.data.row, ctx.data.start_col })
          end,
          unmatched = function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Ignore>", true, false, true), "nx", false)
          end,
        })
      end,
      { "n", "x", "o" },
    },
    ["0F"] = {
      function()
        require("eye.plugin.search").gaze({
          matched = function(ctx)
            vim.api.nvim_buf_set_mark(0, "<", ctx.data.row, ctx.data.start_col, {})
            vim.api.nvim_buf_set_mark(0, ">", ctx.data.row, ctx.data.end_col, {})
            vim.api.nvim_feedkeys("gv", "nx", false)
          end,
          unmatched = function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Ignore>", true, false, true), "nx", false)
          end,
        })
      end,
      { "x", "o" },
    },
    ["0B"] = {
      function()
        require("eye.plugin.line").gaze({
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
        require("eye.plugin.line").gaze({
          matched = function(ctx)
            vim.api.nvim_win_set_cursor(0, { ctx.data.row, 1 })
            vim.api.nvim_feedkeys("o", "n", false)
          end,
        })
      end,
      "n",
    },
    ["0V"] = {
      function()
        local cursor = vim.api.nvim_win_get_cursor(0)
        require("eye.plugin.line").gaze({
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
    ["0dd"] = {
      function()
        require("eye.plugin.line").gaze({
          matched = function(ctx)
            vim.api.nvim_buf_set_lines(0, ctx.data.row - 1, ctx.data.row, false, {})
          end,
        })
      end,
      "n",
    },
    ["0yy"] = {
      function()
        require("eye.plugin.line").gaze({
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
        require("eye.plugin.line").gaze({
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
        require("eye.plugin.line").gaze({
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
        require("eye.plugin.line").gaze({
          matched = function(ctx)
            vim.api.nvim_win_set_cursor(0, { ctx.data.row, 1 })
            vim.api.nvim_feedkeys("Y", "nx", false)
            vim.api.nvim_win_set_cursor(0, cursor)
          end,
        })
      end,
      "n",
    },
    ["0ew"] = {
      function()
        require("eye.plugin.word").gaze({
          regex = function(ctx)
            return ctx["word.inner"]
          end,
          position = 0,
          hl_group = "Visual",
          matched = function(ctx)
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
            vim.api.nvim_win_set_cursor(0, { ctx.data.row, ctx.data.start_col })
            vim.api.nvim_feedkeys("v", "nx", false)
            vim.api.nvim_win_set_cursor(0, { ctx.data.row, ctx.data.end_col - 1 })
          end,
          unmatched = function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Ignore>", true, false, true), "nx", false)
          end,
        })
      end,
      { "x", "o" },
    },
    ["0eW"] = {
      function()
        require("eye.plugin.word").gaze({
          regex = function(ctx)
            return ctx["WORD.inner"]
          end,
          position = 0,
          hl_group = "Visual",
          matched = function(ctx)
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
            vim.api.nvim_win_set_cursor(0, { ctx.data.row, ctx.data.start_col })
            vim.api.nvim_feedkeys("v", "nx", false)
            vim.api.nvim_win_set_cursor(0, { ctx.data.row, ctx.data.end_col - 1 })
          end,
          unmatched = function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Ignore>", true, false, true), "nx", false)
          end,
        })
      end,
      { "x", "o" },
    },
    ["0ww"] = {
      function()
        require("eye.plugin.word").gaze({
          regex = function(ctx)
            return ctx["word.outer"]
          end,
          position = 0,
          hl_group = "Visual",
          matched = function(ctx)
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
            vim.api.nvim_win_set_cursor(0, { ctx.data.row, ctx.data.start_col })
            vim.api.nvim_feedkeys("v", "nx", false)
            vim.api.nvim_win_set_cursor(0, { ctx.data.row, ctx.data.end_col - 1 })
          end,
          unmatched = function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Ignore>", true, false, true), "nx", false)
          end,
        })
      end,
      { "x", "o" },
    },
    ["0wW"] = {
      function()
        require("eye.plugin.word").gaze({
          regex = function(ctx)
            return ctx["WORD.outer"]
          end,
          position = 0,
          hl_group = "Visual",
          matched = function(ctx)
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
            vim.api.nvim_win_set_cursor(0, { ctx.data.row, ctx.data.start_col })
            vim.api.nvim_feedkeys("v", "nx", false)
            vim.api.nvim_win_set_cursor(0, { ctx.data.row, ctx.data.end_col - 1 })
          end,
          unmatched = function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Ignore>", true, false, true), "nx", false)
          end,
        })
      end,
      { "x", "o" },
    },
    ["0el"] = {
      function()
        require("eye.plugin.word").gaze({
          regex = "^\\s*\\zs\\S.*\\S\\ze\\s*$",
          position = 0,
          hl_group = "Visual",
          matched = function(ctx)
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
            vim.api.nvim_win_set_cursor(0, { ctx.data.row, ctx.data.start_col })
            vim.api.nvim_feedkeys("v", "nx", false)
            vim.api.nvim_win_set_cursor(0, { ctx.data.row, ctx.data.end_col - 1 })
          end,
          unmatched = function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Ignore>", true, false, true), "nx", false)
          end,
        })
      end,
      { "x", "o" },
    },
    ["0wl"] = {
      function()
        require("eye.plugin.word").gaze({
          regex = "^\\zs\\s*\\S.*\\S\\ze\\s*$",
          position = 0,
          hl_group = "Visual",
          matched = function(ctx)
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
            vim.api.nvim_win_set_cursor(0, { ctx.data.row, ctx.data.start_col })
            vim.api.nvim_feedkeys("v", "nx", false)
            vim.api.nvim_win_set_cursor(0, { ctx.data.row, ctx.data.end_col - 1 })
          end,
          unmatched = function()
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Ignore>", true, false, true), "nx", false)
          end,
        })
      end,
      { "x", "o" },
    },
    ["0sn"] = {
      function()
        local cursor = vim.api.nvim_win_get_cursor(0)
        require("eye.plugin.line").gaze({
          matched = function(ctx)
            local row = ctx.data.topline - ctx.data.offset
            row = row <= 0 and 1 or row
            vim.cmd("keepjumps normal! " .. row .. "zt")
          end,
        })
        vim.api.nvim_win_set_cursor(0, { cursor[1], cursor[2] })
      end,
      { "n", "x" },
    },
    ["0?"] = {
      function()
        local last_search = vim.fn.getreg("/")
        local row = vim.fn.line(".")
        require("eye.plugin.word").gaze({
          range = function(range)
            return { range.topline, row }
          end,
          position = 0,
          matched = function(ctx)
            vim.api.nvim_win_set_cursor(0, { ctx.data.row, ctx.data.start_col })
          end,
          regex = last_search,
          hl_group = "Visual",
        })
      end,
      "n",
    },
    ["0/"] = {
      function()
        local last_search = vim.fn.getreg("/")
        local row = vim.fn.line(".")
        require("eye.plugin.word").gaze({
          range = function(range)
            return { row, range.botline }
          end,
          position = 0,
          matched = function(ctx)
            vim.api.nvim_win_set_cursor(0, { ctx.data.row, ctx.data.start_col })
          end,
          regex = last_search,
          hl_group = "Visual",
        })
      end,
      "n",
    },
  },
  config = function()
    require("eye").setup()
  end,
}
