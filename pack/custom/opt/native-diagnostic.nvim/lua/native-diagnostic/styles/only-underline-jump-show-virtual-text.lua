local Jump = require("native-diagnostic.jump")

---@type vim.diagnostic.Opts
local config = {
  underline = true,
  jump = { on_jump = Jump.virtual_text },
  virtual_text = false,
  virtual_lines = false,
  severity_sort = true,
}

return config
