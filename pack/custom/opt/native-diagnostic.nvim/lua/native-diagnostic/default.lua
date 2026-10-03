local Sign = require("native-diagnostic.config.sign")
local Highlight = require("native-diagnostic.config.highlight")
--- @type vim.diagnostic.Opts
local diagnostic_config = {
  underline = true,
  -- underline = {
  --   severity = {
  --     vim.diagnostic.severity.HINT,
  --   },
  -- },
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
      [vim.diagnostic.severity.WARN] = "DiagnosticNumberWarn",
      [vim.diagnostic.severity.INFO] = "DiagnosticNumberInfo",
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

local function is_cursor_dignostics(diagnostics)
  local cursor = vim.api.nvim_win_get_cursor(0)
  for _, diagnostic in ipairs(diagnostics) do
    if
      diagnostic.lnum == cursor[1] - 1
      and diagnostic.end_lnum == cursor[1] - 1
      and diagnostic.col <= cursor[2]
      and diagnostic.end_col >= cursor[2]
    then
    elseif diagnostic.lnum == cursor[1] - 1 and diagnostic.end_lnum > cursor[1] - 1 and diagnostic.col <= cursor[2] then
    elseif diagnostic.lnum < cursor[1] - 1 and diagnostic.end_lnum > cursor[1] - 1 then
    elseif
      diagnostic.lnum < cursor[1] - 1
      and diagnostic.end_lnum == cursor[1] - 1
      and diagnostic.end_col <= cursor[2]
    then
    else
      return false
    end
  end
  return true
end

-- Activate highlighting when the cursor enters an unnecessary diagnostic.
local underline = vim.diagnostic.handlers.underline
vim.diagnostic.handlers.underline = {
  show = function(ns, bufnr, _, opts)
    local diagnostics = {}
    for _, d in ipairs(vim.diagnostic.get(bufnr)) do
      if not (d._tags and d._tags.unnecessary and d.severity == 4) then
        table.insert(diagnostics, d)
      end
    end
    underline.show(ns, bufnr, diagnostics, opts)
  end,
  hide = function(ns, bufnr)
    underline.hide(ns, bufnr)
  end,
}
local my_ns = vim.api.nvim_create_namespace("native-diagnostic.underline")
local pre_cursor_dignostics = {}
vim.api.nvim_create_autocmd({ "DiagnosticChanged", "CursorMoved" }, {
  callback = function()
    local unnecessary_diganotics = {}
    local cursor_diagnostics = {}
    local cursor = vim.api.nvim_win_get_cursor(0)
    for _, diagnostic in ipairs(vim.diagnostic.get(0)) do
      if diagnostic._tags and diagnostic._tags.unnecessary and diagnostic.severity == 4 then
        if
          (diagnostic.lnum < cursor[1] - 1 and diagnostic.end_lnum > cursor[1] - 1)
          or (diagnostic.lnum == cursor[1] - 1 and diagnostic.end_lnum > cursor[1] - 1 and diagnostic.col <= cursor[2])
          or (diagnostic.lnum < cursor[1] - 1 and diagnostic.end_lnum == cursor[1] - 1 and diagnostic.end_col >= cursor[2])
          or (
            diagnostic.lnum == cursor[1] - 1
            and diagnostic.end_lnum == cursor[1] - 1
            and diagnostic.col <= cursor[2]
            and diagnostic.end_col >= cursor[2]
          )
        then
          table.insert(cursor_diagnostics, diagnostic)
        else
          table.insert(unnecessary_diganotics, diagnostic)
        end
      end
    end

    if
      not (
        #pre_cursor_dignostics > 0
        and #cursor_diagnostics > 0
        and #pre_cursor_dignostics == #cursor_diagnostics
        and is_cursor_dignostics(pre_cursor_dignostics)
      )
    then
      local buf = vim.api.nvim_get_current_buf()
      underline.hide(my_ns, buf)
      underline.show(my_ns, buf, unnecessary_diganotics)
    end
    pre_cursor_dignostics = cursor_diagnostics
  end,
})

return config
