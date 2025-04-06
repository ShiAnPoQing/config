local M = {}

function M.delSpace(count, mode)
  M.normalModeDelSpace(count, mode)
  M.visualModeDelSpace(mode)
end

local function getResultLines(lines)
  local result = {}

  for _, line in pairs(lines) do
    local newLine = line:gsub("^%s*", "")
    table.insert(result, newLine)
  end

  return result
end

function M.visualModeDelSpace(mode)
  if mode ~= "v" then
    return
  end

  local cursorPos = vim.api.nvim_win_get_cursor(0)

  vim.api.nvim_exec(
    [[
  execute "normal!" . "\<Esc>"
  ]],
    true
  )

  local startPos = vim.api.nvim_buf_get_mark(0, "<")
  local endPos = vim.api.nvim_buf_get_mark(0, ">")

  local startLine = startPos[1]
  local endLine = endPos[1]
  local selectLines = vim.api.nvim_buf_get_lines(0, startLine - 1, endLine, false)
  local result = getResultLines(selectLines)
  vim.api.nvim_buf_set_lines(0, startLine - 1, endLine, false, result)

  vim.api.nvim_win_set_cursor(0, cursorPos)
end

function M.normalModeDelSpace(count, mode)
  if mode ~= "n" then
    return
  end

  local cursorPos = vim.api.nvim_win_get_cursor(0)

  local pos = vim.api.nvim_win_get_cursor(0)
  local column = pos[1]

  local lines = vim.api.nvim_buf_get_lines(0, column - 1, column + count - 1, false)
  local result = getResultLines(lines)
  vim.api.nvim_buf_set_lines(0, column - 1, column + count - 1, false, result)

  vim.api.nvim_win_set_cursor(0, cursorPos)
end

return M
