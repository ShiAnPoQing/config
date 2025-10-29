local M = {}

local sign = {
  [vim.diagnostic.severity.ERROR] = " ",
  [vim.diagnostic.severity.WARN] = " ",
  [vim.diagnostic.severity.HINT] = " ",
  [vim.diagnostic.severity.INFO] = " ",
}

local highlight = {
  [vim.diagnostic.severity.ERROR] = "DiagnosticError",
  [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
  [vim.diagnostic.severity.HINT] = "DiagnosticHint",
  [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
}

--- @type vim.diagnostic.Opts.Float
local float = {
  border = {
    ---@diagnostic disable-next-line: assign-type-mismatch
    { "╔", "DiagnosticInfo" },
    ---@diagnostic disable-next-line: assign-type-mismatch
    { "─", "Normal" },
    ---@diagnostic disable-next-line: assign-type-mismatch
    { "╗", "DiagnosticInfo" },
    ---@diagnostic disable-next-line: assign-type-mismatch
    { "│", "Normal" },
    ---@diagnostic disable-next-line: assign-type-mismatch
    { "╝", "DiagnosticInfo" },
    ---@diagnostic disable-next-line: assign-type-mismatch
    { "─", "Normal" },
    ---@diagnostic disable-next-line: assign-type-mismatch
    { "╚", "DiagnosticInfo" },
    ---@diagnostic disable-next-line: assign-type-mismatch
    { "│", "Normal" },
  },
  spacing = 4,
  source = "if_many",
  prefix = function(diagnostic)
    return " " .. sign[diagnostic.severity], highlight[diagnostic.severity]
  end,
  suffix = function(diagnostic)
    return " [" .. diagnostic.code .. "]", "WarningMsg"
  end,
  header = { "Diagnostics:", "Type" },
}

vim.diagnostic.config({
  underline = true,
  jump = {
    float = float,
  },
  float = float,
  virtual_text = false,
  severity_sort = true,
  signs = {
    text = sign,
  },
})

--- @class LspCollects
--- @field lua string
--- @field vue table<string>
--- @field ts string
--- @field clangd string
--- @field html string
--- @field css string
--- @field json string
local lsp_collects = {
  lua = "lua_ls",
  vue = { "vue_ls", "vtsls" },
  ts = "ts_ls",
  clangd = "clangd",
  html = "html",
  css = "cssls",
  json = "jsonls",
  qml = "qmlls",
  rust = "rust",
}

local function require_lspconfig(source)
  local lsps = {}
  local function r(enables)
    for _, v in ipairs(enables) do
      if type(v) == "string" then
        table.insert(lsps, {
          config = require("neo-lsp.lsps." .. v),
          name = v,
        })
      elseif type(v) == "table" then
        r(v)
      end
    end
  end

  if type(source) == "table" then
    r(source)
  end

  return lsps
end

--- @class LspOptions
--- @field enable fun(collects: LspCollects): table<string>

--- @param opts LspOptions
function M.setup(opts)
  local enables
  if opts.enable ~= nil then
    enables = opts.enable(lsp_collects)
  end
  local lsps = require_lspconfig(enables)
  for _, lsp in ipairs(lsps) do
    if type(lsp.config) == "table" then
      vim.lsp.config(lsp.name, lsp.config)
      vim.lsp.enable(lsp.name)
    end
  end
end

return M
