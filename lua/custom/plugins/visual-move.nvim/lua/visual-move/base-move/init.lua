local M = {}

local function more_line_move() end

local function one_line_move(text, start_row, start_col, end_row, end_col)
  local lines = vim.api.nvim_buf_get_lines(0, start_row - 1, end_row, false)
  vim.print(lines)
  -- local before_text = vim.api.nvim_buf_get_text(0, start_row - 1, 0, start_row - 1, start_col, {})
  -- local after_text = vim.api.nvim_buf_get_text(0, end_row - 1, end_col, end_row - 1, vim.fn.strlen(text), {})
end

--- @param dir "left"| "right"
function M.visual_move(dir)
  local mode = vim.api.nvim_get_mode().mode

  if mode == "s" or mode == "S" then
  end

  if mode == "" then
  end

  if mode == "v" or mode == "V" then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "nx", false)
    local cursor = vim.api.nvim_win_get_cursor(0)
    local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
    local end_row, end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
    local text = vim.api.nvim_buf_get_text(0, start_row - 1, start_col, end_row - 1, end_col + 1, {})

    if end_row > start_row then
      more_line_move()
    else
      one_line_move(text, start_row, start_col, end_row, end_col)
    end
  end

  if mode == "" then
  end
end

return M
