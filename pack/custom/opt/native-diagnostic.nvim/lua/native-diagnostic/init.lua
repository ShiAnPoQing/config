local M = {}

--- @class NativeDiagnostic.Style
--- @field name string
--- @field config vim.diagnostic.Opts|fun():vim.diagnostic.Opts
--- @field preset? "default"|"none"
--- @field on_alternate_jump? "float"|"virtual_text"|"virtual_line"

--- @class NativeDiagnostic.Config
--- @field config? vim.diagnostic.Opts
--- @field styles? NativeDiagnostic.Style[]
--- @field style? string

--- @param config? NativeDiagnostic.Config
function M.setup(config)
  local default_config = require("native-diagnostic.default")
  config = vim.tbl_deep_extend("force", default_config, config or {})
  require("native-diagnostic.style").setup(config)
end

M.choose = require("native-diagnostic.style.choose").choose

return M
