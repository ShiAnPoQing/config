local Sign = require("native-diagnostic.config.sign")

---@type vim.diagnostic.Opts
local config = {
  underline = true,
  jump = { on_jump = function() end },
  virtual_text = {
    prefix = function(diagnostic)
      return " " .. Sign[diagnostic.severity]
    end,
    current_line = true,
  },
  virtual_lines = false,
  severity_sort = true,
}

return config
