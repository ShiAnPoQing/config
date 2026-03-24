return {
  name = "eye.nvim",
  key = {
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
            vim.api.nvim_win_set_cursor(0, { row+1, col })
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
