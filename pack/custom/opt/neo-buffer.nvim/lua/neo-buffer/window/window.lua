local M = {}

M.default_win_option = {
  number = true,
  relativenumber = true,
  cursorline = true,
  signcolumn = "yes",
  winfixbuf = true,
}

M.default_config = {
  relative = "editor",
  height = 10,
  col = 0,
  style = "minimal",
  border = "single",
  title = "Buffer Manage",
  title_pos = "center",
}

function M.set_win_option(win, option)
  option = vim.tbl_extend("force", M.default_win_option, option or {})
  for key, value in pairs(option) do
    vim.api.nvim_set_option_value(key, value, {
      win = win,
    })
  end
end

return M
