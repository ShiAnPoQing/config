local U = require("native-diagnostic.style.util")

--- @class NativeDiagnostic.style
--- @field styles NativeDiagnostic.Style[]
--- @field style NativeDiagnostic.Style
local M = {}

---@return vim.diagnostic.Opts
local function get_style_config(style)
  return require("native-diagnostic.styles." .. style)
end

--- @param style NativeDiagnostic.Style
local function resolve_style(style)
  if type(style.config) == "function" then
    style.config = style.config()
  end
  return style
end

--- @param config NativeDiagnostic.Config
function M.setup(config)
  M.styles = { {
    name = "default",
    config = config.config,
    preset = "none",
  } }
  M._register(config.styles)
  M.set_style(config.style or "default")
end

---@param styles NativeDiagnostic.Style[]
function M._register(styles)
  M._register_user_styles(styles)
  M._register_builtin_styles()
end

---@param styles NativeDiagnostic.Style[]
function M._register_user_styles(styles)
  local default_style = M.styles[1]
  local default_config = default_style.config --[[@as vim.diagnostic.Opts]]
  for _, style in ipairs(styles) do
    if style.preset == "default" then
      style.config = vim.tbl_deep_extend("force", default_config, style.config or {})
    end
    M.styles[#M.styles + 1] = style
  end
end

function M._register_builtin_styles()
  local default_style = M.styles[1]
  local default_config = default_style.config --[[@as vim.diagnostic.Opts]]
  for _, path in ipairs(vim.fn.globpath(U.get_style_path(), "*", false, true)) do
    local style_name = vim.fn.fnamemodify(path, ":t:r")
    M.styles[#M.styles + 1] = {
      name = style_name,
      config = function()
        local config = get_style_config(style_name)
        return vim.tbl_deep_extend("force", default_config, config)
      end,
      preset = "none",
    }
  end
end

function M.set_style(name)
  for _, style in ipairs(M.styles) do
    if style.name == name then
      M.style = resolve_style(style)
      break
    end
  end
  if M.style then
    vim.diagnostic.config(M.style.config --[[@as vim.diagnostic.Opts]])
  end
end

return M
