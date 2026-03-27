local Sign = require("native-diagnostic.config.sign")
local Jump = require("native-diagnostic.jump")

---@type vim.diagnostic.Opts
local config = {
  underline = true,
  jump = { on_jump = Jump.virtual_text },
  virtual_text = {
    prefix = function(diagnostic)
      return " " .. Sign[diagnostic.severity]
    end,
    source = "if_many",
  },
  virtual_lines = false,
  severity_sort = true,
}

return config
