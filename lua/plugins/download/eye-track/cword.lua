local M = {}

function M.create_search_cword_keymap(flag)
  local get_keyword

  if flag then
    get_keyword = function()
      return "\\<" .. vim.fn.expand("<cword>") .. "\\>"
    end
  else
    get_keyword = function()
      return vim.fn.expand("<cword>")
    end
  end

  return {
    {
      function(ctx)
        local cword = ctx.context.get_keyword()
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
    context = {
      get_keyword = get_keyword,
    },
  }
end

return M
