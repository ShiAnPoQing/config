---@type vim.diagnostic.Opts
local config = {
  underline = true,
  jump = { on_jump = function() end },
  virtual_text = false,
  virtual_lines = {
    current_line = true,
  },
  severity_sort = true,
}

return config
