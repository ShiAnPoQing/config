--- @class my.insert.VISUAL
local M = {}
local VISUAL = "v"

function M.first()
  local count = vim.v.count1
  vim.cmd("normal! " .. VISUAL)
  local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
  vim.api.nvim_win_set_cursor(0, { start_row, start_col })
  vim.api.nvim_feedkeys(count .. "i", "nt", false)
end

function M.last()
  local count = vim.v.count1
  vim.cmd("normal! " .. VISUAL)
  local row, col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
  vim.api.nvim_win_set_cursor(0, { row, col })
  vim.api.nvim_feedkeys(count .. "a", "nt", false)
end

function M.first_non_blank()
  local count = vim.v.count1
  vim.cmd("normal! " .. VISUAL)
  local start_row, start_col = unpack(vim.api.nvim_buf_get_mark(0, "<"))
  vim.api.nvim_win_set_cursor(0, { start_row, start_col })
  vim.api.nvim_feedkeys(count .. "i", "nt", false)
end

function M.last_non_blank()
  local count = vim.v.count1
  vim.cmd("normal! " .. VISUAL)
  local row, col = unpack(vim.api.nvim_buf_get_mark(0, ">"))
  vim.api.nvim_win_set_cursor(0, { row, col })
  vim.api.nvim_feedkeys(count .. "a", "nt", false)
end

return M
