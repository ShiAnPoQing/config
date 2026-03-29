local M = {}

local default_config = {
  active = true,
}

---@class Cursorline.Config
---@field active? boolean

---@param config? Cursorline.Config
function M.setup(config)
  config = vim.tbl_deep_extend("force", default_config, config or {})

  if config.active then
    vim.opt_local.cursorline = false
    require("cursorline.core"):toggle()
  end
end

return M
