---@type vim.diagnostic.Opts
local config = {
  underline = false,
  jump = { on_jump = function() end },
  virtual_text = false,
  virtual_lines = true,
  severity_sort = true,
}

return config
