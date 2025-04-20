local function set_mark(start_pos, end_pos)
  vim.api.nvim_buf_set_mark(0, "<", start_pos[1], start_pos[2], {})
  vim.api.nvim_buf_set_mark(0, ">", end_pos[1], end_pos[2], {})
end

--- @param action "left"|"right"
local function move_select_text(action)
  vim.api.nvim_exec2([[
  execute "normal! \<Esc>"
  ]], {})

  local select_start_mark = vim.api.nvim_buf_get_mark(0, "<")
  local select_end_mark = vim.api.nvim_buf_get_mark(0, ">")
  local start_row = select_start_mark[1]
  local start_col = select_start_mark[2]
  local end_row = select_end_mark[1]
  local end_col = select_end_mark[2]

  local line = vim.api.nvim_get_current_line()
  local line_to_start = line:sub(1, start_col)
  local line_to_end = line:sub(select_end_mark[2] + 2)
  local selects = vim.api.nvim_buf_get_text(0, start_row - 1, start_col, end_row - 1,
    end_col + 1, {})

  local new_line;

  local Action = {
    ["left"] = {
      get_new_line = function()
        return line_to_start:sub(1, -2) .. selects[1] .. line_to_start:sub(-1) .. line_to_end
      end,
      set_new_mark = function()
        set_mark({ start_row, start_col - 1 }, { start_row, end_col - 1 })
      end
    },
    ["right"] = {
      get_new_line = function()
        return line_to_start .. line_to_end:sub(1, 1) .. selects[1] .. line_to_end:sub(2)
      end,
      set_new_mark = function()
        set_mark({ start_row, start_col + 1 }, { start_row, end_col + 1 })
      end
    }
  }

  vim.api.nvim_buf_set_text(0, start_row - 1, start_col, end_row - 1,
    end_col + 1, {})

  if #selects == 1 then
    new_line = Action[action].get_new_line()
  end
  vim.api.nvim_buf_set_lines(0, start_row - 1, start_row, false, { new_line })

  Action[action].set_new_mark()

  vim.api.nvim_exec2([[
  execute "normal! gv\<C-g>"
  ]], {})
end



return {
  ["<M-left>"] = {
    function()
      move_select_text("left")
    end,
    "s"
  },
  ["<M-right>"] = {
    function()
      move_select_text("right")
    end,
    "s"
  }
}
