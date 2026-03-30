--- @class Eye.C.Label
--- @field config Eye.Config.Label
local label = {
  config = {
    -- stylua: ignore
    include = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", },
    exclude = {},
    extmark = {
      virt_text_pos = "overlay",
    },
    highlight = {
      group = { "EyeLabel", "EyeNextLabel" },
      show_next_key = true,
    },
  },
}
--- @class Eye.C.Layer
--- @field config Eye.Config.Layer.Config
local layer = {
  config = {
    enable = true,
    group = "EyeLayer",
  },
}

--- @class Eye.C
--- @field config Eye.Config
local M = {
  label = label,
  layer = layer,
  config = {
    matched = nil,
    start = nil,
    finish = nil,
    completed = nil,
    cancelled = nil,
  },
}

--- @param config Eye.Config.Label|Eye.Config.BaseLabel
--- @param parent? Eye.Config.Label
--- @return Eye.Config.Label
function label:proxy(config, parent)
  config = config or {}

  if not parent then
    if config.exclude then
      local include = {}
      for _, char in ipairs(self.config.include) do
        if not vim.list_contains(config.exclude, char) then
          table.insert(include, char)
        end
      end
      config.include = include
    end
    parent = self.config
  end

  return setmetatable({
    include = config.include,
    exclude = config.exclude,
    matched = config.matched,
    extmark = setmetatable(config.extmark or {}, { __index = parent.extmark }),
    highlight = setmetatable(config.highlight or {}, { __index = parent.highlight }),
  }, { __index = parent }) --[[@as Eye.Config.Label]]
end

--- @param config Eye.Config.Layer.Config
--- @param parent? Eye.Config.Layer.Config
--- @return Eye.Config.Layer.Config
function layer:proxy(config, parent)
  config = config or {}
  parent = parent or self.config
  return setmetatable({
    enable = config.enable,
    group = config.group,
  }, { __index = parent or self.config }) --[[@as Eye.Config.Layer.Config]]
end

--- @param config Eye.RootGroup.Config
--- @param parent? Eye.RootGroup.Config
--- @return Eye.RootGroup.Config
function M:proxy(config, parent)
  config = config or {}
  parent = parent or self.config
  return setmetatable({
    label = self.label:proxy(config.label, parent.label),
    layer = self.layer:proxy(config.layer, parent.layer),
    start = config.start,
    finish = config.finish,
    completed = config.completed,
    cancelled = config.cancelled,
  }, { __index = parent }) --[[@as Eye.RootGroup.Config]]
end

return M
