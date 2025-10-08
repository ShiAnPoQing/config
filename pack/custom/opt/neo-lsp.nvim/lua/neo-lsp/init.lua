local M = {}

vim.diagnostic.config({
  -- virtual_text = {
  --   spacing = 4,
  --   source = "if_many",
  --   prefix = "●",
  -- },
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
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
