local M = {}

function M.createFloat()
  local parent_width = vim.api.nvim_win_get_width(0)
  local parent_height = vim.api.nvim_win_get_height(0)

  local row = math.ceil((parent_height * 0.3) / 2)
  local col = math.ceil(parent_width - 10)

  local opts = {
    relative = "editor",
    width = 10,
    row = row,
    col = col,
    height = 2,
    anchor = "NW",
    title = { { "Record", "Normal" } },
    title_pos = "center",
    style = "minimal",
    border = require("custom.style.float.border").border2,
  }
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
  local win = vim.api.nvim_open_win(buf, true, opts)

  return win, buf
end

return M
