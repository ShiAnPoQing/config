local M = {}

local function set_surround_mark(mc)
  local esc = vim.api.nvim_replace_termcodes("<Esc>", true, true, true)
  vim.api.nvim_feedkeys("va" .. mc .. esc, "nx", false)
end

local function delete_surround_match(count, mc)
  if count == 0 then
    return
  end

  local start_pos = vim.api.nvim_win_get_cursor(0)

  set_surround_mark(mc)

  local visual_start_row, visual_start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
  local visual_end_row, visual_end_col = unpack(vim.api.nvim_buf_get_mark(0, ">"))

  if visual_start_col == visual_end_col and visual_start_row == visual_end_row then
    return
  end

  vim.api.nvim_buf_set_text(0, visual_end_row - 1, visual_end_col, visual_end_row - 1, visual_end_col + 1, {})
  vim.api.nvim_buf_set_text(0, visual_start_row - 1, visual_start_col, visual_start_row - 1, visual_start_col + 1, {})

  if visual_start_row == start_pos[1] then
    vim.api.nvim_win_set_cursor(0, { start_pos[1], start_pos[2] - 1 })
  else
    vim.api.nvim_win_set_cursor(0, start_pos)
  end

  delete_surround_match(count - 1, mc)
end

function M.delete(mc)
  delete_surround_match(vim.v.count1, mc)
end

return M
