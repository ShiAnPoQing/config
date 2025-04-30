local M = {}

local function visualModeAlign(align)
  vim.api.nvim_exec2([[exec "normal! \<Esc>"]], {})

  local start_pos = vim.api.nvim_buf_get_mark(0, "<")
  local end_pos = vim.api.nvim_buf_get_mark(0, ">")
  local win_width = vim.api.nvim_get_option("columns") - 8
  local filter_req = "^[%s]*(.+)[%s]*$"

  local lines = vim.api.nvim_buf_get_lines(0, start_pos[1] - 1, end_pos[1], false)
  local newLines = {}

  if align == "left" then
    for _, line in ipairs(lines) do
      table.insert(newLines, line:match(filter_req))
    end
  end

  if align == "right" then
    for _, line in ipairs(lines) do
      local newLine = line:match(filter_req)
      local space_count = win_width - #newLine
      table.insert(newLines, string.rep("", space_count, " ") .. newLine)
    end
  end

  if align == "middle" then
    for _, line in ipairs(lines) do
      local newLine = line:match(filter_req)
      local space_count = (win_width - #newLine) / 2
      table.insert(newLines, string.rep("", space_count, " ") .. newLine)
    end
  end

  vim.api.nvim_buf_set_lines(0, start_pos[1] - 1, end_pos[1], false, newLines)
end

local function normalModeAlign(align)
  local current_pos = vim.api.nvim_win_get_cursor(0)
  local win_width = vim.api.nvim_get_option("columns") - 8

  local line = vim.api.nvim_buf_get_lines(0, current_pos[1] - 1, current_pos[1], false)[1]:match("^[%s]*(.+)[%s]*$")

  if align == "left" then
    vim.api.nvim_buf_set_lines(0, current_pos[1] - 1, current_pos[1], false, { line })
    return
  end

  if align == "right" then
    local space_count = win_width - #line
    local newLine = string.rep("", space_count, " ") .. line
    vim.api.nvim_buf_set_lines(0, current_pos[1] - 1, current_pos[1], false, { newLine })
    return
  end

  if align == "middle" then
    local space_count = (win_width - #line) / 2
    local newLine = string.rep("", space_count, " ") .. line
    vim.api.nvim_buf_set_lines(0, current_pos[1] - 1, current_pos[1], false, { newLine })
    return
  end
end

function M.textAlign(data)
  if data.mode == "n" then
    normalModeAlign(data.align)
    return
  end

  if data.mode == "v" then
    visualModeAlign(data.align)
    return
  end
end

return M
