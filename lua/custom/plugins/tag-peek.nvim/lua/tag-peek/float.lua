local M = {}

--- @class TagPeekFloatOptions

--- @param opts? TagPeekFloatOptions
function M.float(opts)
  local neovim_width = vim.o.columns
  local neovim_height = vim.o.lines
  local default_config = {
    relative = "editor",
    row = 2,
    col = math.floor((neovim_width - 80) / 2),
    width = 80,
    height = 10,
    style = "minimal",
    border = "rounded",
    title = "Tag Peek",
    title_pos = "center",
    focusable = true,
  }
  M.buf = vim.api.nvim_create_buf(false, true)
  M.win = vim.api.nvim_open_win(M.buf, true, default_config)
end

return M
