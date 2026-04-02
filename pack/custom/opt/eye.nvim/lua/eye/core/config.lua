local Layer = require("eye.core.layer")
local Label = require("eye.core.label")
local M = {}

--- @type Eye.Config
local default_config = {
  label = Label.config,
  layer = Layer.config,
}

--- @param config Eye.Config
--- @return Eye.Config
function M:resolve(config)
  config = vim.tbl_deep_extend("force", default_config, config or {}) --[[@as Eye.Config]]

  if config.label.exclude then
    local include = {}
    for _, char in ipairs(self.config.label.include) do
      if not vim.list_contains(config.label.exclude, char) then
        table.insert(include, char)
      end
    end
    config.label.include = include
  end

  return config
end

M.config = default_config

return M
