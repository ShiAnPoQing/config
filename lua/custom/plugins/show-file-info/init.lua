local M = {}

local MAXWIDTH = 50
local WIN_ID

function M.show_file_info()
  if WIN_ID then
    pcall(vim.api.nvim_win_close, WIN_ID, false)
    WIN_ID = nil
    return
  end

  local info = vim.fn.expand("%:p")
  local width = #info < MAXWIDTH and #info or MAXWIDTH
  local parent_width = vim.api.nvim_win_get_width(0)
  local parent_height = vim.api.nvim_win_get_height(0)

  local row = math.ceil((parent_height - 2) / 2)
  local col = math.ceil((parent_width - width) / 2)

  local opts = {
    relative = "editor",
    width = width,
    row = row,
    col = col,
    height = 2,
    anchor = "NW",
    title = { { "FileInfo", "Normal" } },
    title_pos = "center",
    style = "minimal",
    border = require("custom.style.float.border").border2,
  }
  local buf = vim.api.nvim_create_buf(false, true)

  local line_count = vim.api.nvim_buf_line_count(0)
  vim.api.nvim_buf_set_lines(buf, 0, 1, false, { info, line_count .. " lines" })

  WIN_ID = vim.api.nvim_open_win(buf, true, opts)
  vim.api.nvim_buf_set_option(buf, "modifiable", false)
  require("utils.float.win-move").load(buf, {})
end

function M.setup(opt)
  vim.api.nvim_create_user_command("ShowFileInfo", function()
    M.show_file_info()
  end, {})
end

return M
