local M = {}

function M.line_concat()
  local mode = vim.api.nvim_get_mode().mode
  local cursor_pos = vim.api.nvim_win_get_cursor(0)

  _G.custom_line_concat = function(type)
    if type ~= "line" then
      return
    end
    local start_mark = vim.api.nvim_buf_get_mark(0, "[")
    local end_mark = vim.api.nvim_buf_get_mark(0, "]")

    local line_count = end_mark[1] - start_mark[1]
    if line_count > 1 then
      line_count = line_count + 1
    end

    vim.api.nvim_feedkeys(line_count .. "J", "nx", false)

    if mode == "V" then
      if cursor_pos[1] > start_mark[1] then
        vim.api.nvim_win_set_cursor(0, { start_mark[1], cursor_pos[2] })
      else
        vim.api.nvim_win_set_cursor(0, cursor_pos)
      end
    else
      vim.api.nvim_win_set_cursor(0, cursor_pos)
    end
  end

  vim.opt.operatorfunc = "v:lua.custom_line_concat"
end

return M
