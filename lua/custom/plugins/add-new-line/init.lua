local M = {}

local ModeAction = {
  ["n"] = {
    get_indent = function()

    end
  },
  ["i"] = {
    get_indent = function()
      local line = vim.api.nvim_get_current_line()
      local indent = line:gsub()
    end
  }
}

function M.add_new_line(mode, count, updown)
  local begin_pos = vim.api.nvim_win_get_cursor(0)
  local end_pos
  local i = count

  if mode == "i" then

  end

  if updown == "down" then
    while i > 0 do
      vim.api.nvim_buf_set_lines(0, begin_pos[1], begin_pos[1], false, { "" })
      i = i - 1
    end
    end_pos = { begin_pos[1] + count, begin_pos[2] }
  elseif updown == "up" then
    while i > 0 do
      vim.api.nvim_buf_set_lines(0, begin_pos[1] - 1, begin_pos[1] - 1, false, { "" })
      i = i - 1
    end
    end_pos = begin_pos
  end

  vim.api.nvim_win_set_cursor(0, end_pos)
end

return M
