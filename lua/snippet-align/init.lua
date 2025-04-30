local M = {}

local function visualModeAlign(align)
  vim.api.nvim_exec2([[  exec "normal! " .. "\<Esc>"  ]], {})
  local filter_req = "^[%s]*(.+)[%s]*$"

  local start_pos = vim.api.nvim_buf_get_mark(0, "<")
  local end_pos = vim.api.nvim_buf_get_mark(0, ">")

  local lines = vim.api.nvim_buf_get_lines(0, start_pos[1] - 1, end_pos[1], false)

  if align == "right" then
    local MaxLength = 0
    for _, line in ipairs(lines) do
      local newLine = line:match(filter_req)
    end
  end
end

local function normalModeAlign(align)
  return
end

function M.snippetAlign(data)
  if data.mode == "n" then
    return normalModeAlign(data.align)
  end

  if data.mode == "v" then
    return visualModeAlign(data.align)
  end
end

return M
