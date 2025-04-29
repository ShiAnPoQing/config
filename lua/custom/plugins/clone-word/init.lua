local M = {}

local function should_clone_down(cursor_row, cursor_col)
  local buf_line_count = vim.api.nvim_buf_line_count(0)
  if buf_line_count == cursor_row then
    return false
  end

  local line = vim.api.nvim_buf_get_lines(0, cursor_row, cursor_row + 1, false)[1]
  if #line <= cursor_col + 1 then
    return false
  end

  return true
end

local function should_clone_up(cursor_row)
  if cursor_row == 1 then
    return false
  end
  return true
end

local function clone_up(count, mode, cursor_row, cursor_col)
  if not should_clone_up(cursor_row) then return end

  if mode == "n" then
    vim.api.nvim_feedkeys("k", "n", true)
    if cursor_col ~= 0 then
      vim.api.nvim_feedkeys("l", "n", true)
    end
    vim.api.nvim_feedkeys("v" .. count .. "e" .. '"ayj', "n", true)
    vim.api.nvim_feedkeys("i", "n", true)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-R>a", true, true, true), "n", true)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", true)
  elseif mode == "i" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", true)
    vim.api.nvim_feedkeys("k", "n", true)
    if cursor_col ~= 0 then
      vim.api.nvim_feedkeys("l", "n", true)
    end
    vim.api.nvim_feedkeys("v" .. count .. "e" .. '"ayj', "n", true)
    vim.api.nvim_feedkeys("i", "n", true)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-R>a", true, true, true), "n", true)
  end
end

local function clone_down(count, mode, cursor_row, cursor_col)
  if not should_clone_down(cursor_row, cursor_col) then return end
  if mode == "n" then
    vim.api.nvim_feedkeys("j", "n", true)
    if cursor_col ~= 0 then
      vim.api.nvim_feedkeys("l", "n", true)
    end
    vim.api.nvim_feedkeys("v" .. count .. "e" .. '"ayk', "n", true)
    vim.api.nvim_feedkeys("i", "n", true)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-R>a", true, true, true), "n", true)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", true)
  elseif mode == "i" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, true, true), "n", true)
    vim.api.nvim_feedkeys("j", "n", true)
    if cursor_col ~= 0 then
      vim.api.nvim_feedkeys("l", "n", true)
    end
    vim.api.nvim_feedkeys("v" .. count .. "e" .. '"ayk', "n", true)
    vim.api.nvim_feedkeys("i", "n", true)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-R>a", true, true, true), "n", true)
  end
end

--- @param dir "up"|"down"
--- @param count integer
function M.copy_line_word(dir, count)
  local mode = vim.api.nvim_get_mode().mode
  local cursor_row, cursor_col = unpack(vim.api.nvim_win_get_cursor(0))

  if dir == "up" then
    clone_up(count, mode, cursor_row, cursor_col)
  elseif dir == "down" then
    clone_down(count, mode, cursor_row, cursor_col)
  end
end

return M
