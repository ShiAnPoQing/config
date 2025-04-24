local M = {}

function M.copy_line_word(UD, count, mode)
  local current_row = vim.api.nvim_win_get_cursor(0)[1]
  local current_col = vim.api.nvim_win_get_cursor(0)[2]
  local buf_line_count = vim.api.nvim_buf_line_count(0)

  local lines

  if UD == "up" then
    if current_row == 1 then
      return
    end

    if mode == "i" then
      local Esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
      vim.api.nvim_feedkeys(Esc, "n", true)
    end

    vim.api.nvim_feedkeys("k", "n", true)

    if current_col ~= 0 then
      vim.api.nvim_feedkeys("l", "n", true)
    end

    vim.api.nvim_feedkeys("v" .. count .. "e" .. '"ayj', "n", true)

    vim.api.nvim_feedkeys("i", "n", true)
    local C_r = vim.api.nvim_replace_termcodes("<C-R>a", true, true, true)
    vim.api.nvim_feedkeys(C_r, "n", true)

    if mode == "n" then
      local Esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
      vim.api.nvim_feedkeys(Esc, "n", true)
    end
  elseif UD == "down" then
    if buf_line_count == current_row then
      return
    end

    lines = vim.api.nvim_buf_get_lines(0, current_row, current_row + 1, false)

    if #lines[1] <= current_col + 1 then
      return
    end

    if mode == "i" then
      local Esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
      vim.api.nvim_feedkeys(Esc, "n", true)
    end

    vim.api.nvim_feedkeys("j", "n", true)

    if current_col ~= 0 then
      vim.api.nvim_feedkeys("l", "n", true)
    end
    vim.api.nvim_feedkeys("v" .. count .. "e" .. '"ayk', "n", true)

    vim.api.nvim_feedkeys("i", "n", true)
    local C_r = vim.api.nvim_replace_termcodes("<C-R>a", true, true, true)
    vim.api.nvim_feedkeys(C_r, "n", true)

    if mode == "n" then
      local Esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
      vim.api.nvim_feedkeys(Esc, "n", true)
    end
  end
end

return M
