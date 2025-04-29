local M = {}

function M.copy_line_word(dir, count)
  local mode = vim.api.nvim_get_mode().mode
  local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))
  local buf_line_count = vim.api.nvim_buf_line_count(0)

  local lines

  if dir == "up" then
    if cursor_row == 1 then
      return
    end

    -- if mode == "i" then
    --   vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", true)
    -- end

    vim.api.nvim_feedkeys("k", "n", true)

    if cursor_col ~= 0 then
      vim.api.nvim_feedkeys("l", "n", true)
    end

    vim.api.nvim_feedkeys("v" .. count .. "e" .. '"ayj', "n", true)
    vim.api.nvim_feedkeys("i", "n", true)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-R>a", true, true, true), "n", true)

    if mode == "n" then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", true)
    end
  elseif dir == "down" then
    if buf_line_count == cursor_row then
      return
    end

    lines = vim.api.nvim_buf_get_lines(0, cursor_row, cursor_row + 1, false)

    if #lines[1] <= cursor_col + 1 then
      return
    end

    if mode == "i" then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", true)
    end

    vim.api.nvim_feedkeys("j", "n", true)
    if cursor_col ~= 0 then
      vim.api.nvim_feedkeys("l", "n", true)
    end
    vim.api.nvim_feedkeys("v" .. count .. "e" .. '"ayk', "n", true)
    vim.api.nvim_feedkeys("i", "n", true)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-R>a", true, true, true), "n", true)

    if mode == "n" then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", true)
    end
  end
end

return M
