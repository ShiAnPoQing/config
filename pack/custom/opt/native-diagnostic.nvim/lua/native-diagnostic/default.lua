local Sign = require("native-diagnostic.config.sign")
local Highlight = require("native-diagnostic.config.highlight")

--- @type vim.diagnostic.Opts
local diagnostic_config = {
  underline = {
    severity = {
      vim.diagnostic.severity.HINT,
    },
  },
  float = {
    border = {
      { "╔", "Label" },
      { "─", "Normal" },
      { "╗", "Label" },
      { "│", "Normal" },
      { "╝", "Label" },
      { "─", "Normal" },
      { "╚", "Label" },
      { "│", "Normal" },
    },
    spacing = 4,
    source = "if_many",
    prefix = function(diagnostic, i, total)
      local kind
      if i == total then
        kind = "└─"
      else
        kind = "├─"
      end
      return kind .. Sign[diagnostic.severity], Highlight[diagnostic.severity]
    end,
    suffix = function(diagnostic)
      return " [" .. diagnostic.code .. "]", Highlight[diagnostic.severity]
    end,
    header = { "Diagnostics:", "Type" },
  },
  jump = { on_jump = function() end },
  virtual_text = {
    source = "if_many",
    prefix = function(diagnostic)
      return Sign[diagnostic.severity]
    end,
  },
  virtual_lines = false,
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "█",
      [vim.diagnostic.severity.WARN] = "█",
      [vim.diagnostic.severity.INFO] = "█",
      [vim.diagnostic.severity.HINT] = "█",
    },
    linehl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticLineError",
      [vim.diagnostic.severity.WARN] = "DiagnosticLineWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticLineInfo",
    },
    numhl = {
      [vim.diagnostic.severity.ERROR] = "DiagnosticNumberError",
      [vim.diagnostic.severity.WARN] = "DiagnosticLineWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticLineInfo",
    },
  },
}

---@type NativeDiagnostic.Config
local config = {
  style = "default",
  styles = {
    default = {
      config = diagnostic_config,
      preset = "none",
      on_alternate_jump = "float",
    },
  },
  config = diagnostic_config,
}

return config
