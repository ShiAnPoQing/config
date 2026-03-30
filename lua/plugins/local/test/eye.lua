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
    ["<leader>-"] = {
      function()
        require("eye.plugin.word").gaze({
          regex = function(builtin)
            return builtin["word.inner"]
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
    ["0f"] = {
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
