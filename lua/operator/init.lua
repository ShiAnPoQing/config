local M = {}

function M.setup()
  local wrap_opts = {
    enter = function()
      return { cursor = vim.api.nvim_win_get_cursor(0) }
    end,
    done = function(ctx)
      vim.api.nvim_win_set_cursor(0, ctx.cursor)
    end,
  }

  local wrap_opts2 = {
    enter = function()
      return { cursors = my.multicursor.get(0, 0, -1) }
    end,
    done = function(ctx)
      for _, c in ipairs(ctx.cursors) do
        vim.api.nvim_buf_set_extmark(0, my.multicursor.ns, c[2], c[3], { id = c[1] })
      end
    end,
  }

  --- gu{motion} but keep cursor position
  my.operator.wrap("gu", wrap_opts, wrap_opts2)
  --- gU{motion} but keep cursor position
  my.operator.wrap("gU", wrap_opts, wrap_opts2)
  --- g~{motion} but keep cursor position
  my.operator.wrap("g~", wrap_opts, wrap_opts2)
  --- y{motion} but keep cursor position
  my.operator.wrap("y", wrap_opts, wrap_opts2)
end

return M
