return {
  name = "eye-track.nvim",
  key = {
    ["0<space><space>w"] = {
      function()
        require("eye-track.plugins.line-start-end")({
          position = -2,
          matched = function(ctx)
            vim.api.nvim_win_set_cursor(0, { ctx.row, ctx.col })
            vim.api.nvim_feedkeys("i", "n", false)
          end,
        })
      end,
      "n",
    },
    ["0<space><space>e"] = {
      function()
        require("eye-track.plugins.line-start-end")({
          position = 2,
          matched = function(ctx)
            vim.api.nvim_win_set_cursor(0, { ctx.row, ctx.col })
            vim.api.nvim_feedkeys("a", "n", false)
          end,
        })
      end,
      "n",
    },

    ["0<space>w"] = {
      function()
        require("eye-track.plugins.line-start-end")({
          position = -1,
          matched = function(ctx)
            vim.api.nvim_win_set_cursor(0, { ctx.row, ctx.col })
            vim.api.nvim_feedkeys("i", "n", false)
          end,
        })
      end,
      "n",
    },
    ["0<space>e"] = {
      function()
        require("eye-track.plugins.line-start-end")({
          position = 1,
          matched = function(ctx)
            vim.api.nvim_win_set_cursor(0, { ctx.row, ctx.col })
            vim.api.nvim_feedkeys("a", "n", false)
          end,
        })
      end,
      "n",
    },
    -- ["0#"] = require("plugins.download.eye-track.cword").create_search_cword_keymap(true),
    -- ["0g#"] = require("plugins.download.eye-track.cword").create_search_cword_keymap(false),
    -- ["0*"] = require("plugins.download.eye-track.cword").create_search_cword_keymap(true),
    -- ["0g*"] = require("plugins.download.eye-track.cword").create_search_cword_keymap(false),
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
    ["0<C-M-k>"] = {
      function()
        local row = vim.fn.line(".")
        require("eye-track.plugins.line")({
          range = function(range)
            return { range.topline, row }
          end,
          matched = function(ctx)
            require("move-line").move_line(ctx.offset)
          end,
        })
      end,
      { "n", "x" },
      depend = "move-line",
    },
    ["0<C-M-j>"] = {
      function()
        local row = vim.fn.line(".")
        require("eye-track.plugins.line")({
          range = function(range)
            return { row, range.botline }
          end,
          matched = function(ctx)
            require("move-line").move_line(ctx.offset)
          end,
        })
      end,
      { "n", "x" },
      depend = "move-line",
    },
    ["0<C-up>"] = {
      function()
        require("eye-track.plugins.line")({
          matched = function(ctx)
            require("move-line").move_line(ctx.offset)
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
            require("move-line").move_line(ctx.offset)
          end,
        })
      end,
      { "n", "x" },
      depend = "move-line",
    },
    ["0<space><space>l"] = {
      function()
        require("eye-track.plugins.line-start-end")({
          position = 2,
          matched = function(ctx)
            vim.api.nvim_win_set_cursor(0, { ctx.row, ctx.col })
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
            vim.api.nvim_win_set_cursor(0, { ctx.row, ctx.col })
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
            vim.api.nvim_win_set_cursor(0, { ctx.row, ctx.col })
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
            vim.api.nvim_win_set_cursor(0, { ctx.row, ctx.col })
          end,
        })
      end,
      "n",
    },
  },
  config = function()
    require("eye-track").setup({})
  end,
}
