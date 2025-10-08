local M = {}

--- @class CodeActionWinOptions
--- @field lines? string[]
--- @field config? vim.api.keyset.win_config
--- @field win_options? vim.api.keyset.option
--- @field buf_options? vim.api.keyset.option

local default_config = {
  relative = "cursor",
  row = 1,
  col = 0,
  width = 20,
  height = 20,
  style = "minimal",
  border = "single",
}

--- @param options? CodeActionWinOptions
function M:open(options)
  options = options or {}
  local win_options = options.win_options or {}
  local buf_options = options.buf_options or {}
  local config = vim.tbl_deep_extend("force", default_config, options.config or {})
  local buf = vim.api.nvim_create_buf(false, true)
  local ok, win = pcall(vim.api.nvim_open_win, buf, true, config)

  if not ok then
    return
  end

  self.win = win
  self.buf = buf
  vim.api.nvim_set_option_value("number", true, { win = win })
  vim.api.nvim_set_option_value("cursorline", true, { win = win })
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, options.lines or {})
  vim.api.nvim_set_option_value("modifiable", false, { buf = buf })
end

function M:close()
  if not self.win then
    return
  end
  pcall(vim.api.nvim_win_close, self.win, true)
end

return M
