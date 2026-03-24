--- @class Eye._Config
--- @field hook Eye._Config._Hook
--- @field label Eye._Config._Label
--- @field layer Eye._Config._Layer

--- @class Eye._Config._Label
--- @field base Eye.Config.Label.Base
--- @field hook Eye.Config.Label.Hook
--- @field extmark? Eye.Config.Label.Extmark
--- @field highlight? Eye.Config.Label.Highlight

--- @class Eye._Config._Layer: Eye.Config.Layer

--- @class Eye._Config._Hook: Eye.Config.Hook

--- @class Eye.C.Label
--- @field config Eye._Config._Label
local label = {
  config = {
    base = {
      -- stylua: ignore
      include = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", },
      exclude = {},
    },
    hook = {},
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
--- @field config Eye._Config._Layer
local layer = {
  config = {
    enable = true,
    highlight = {
      {
        group = "EyeLayer",
        range = function(ctx)
          return { ctx.topline - 1, ctx.botline }
        end,
      },
    },
  },
}

--- @class Eye.C.Hook
--- @field config Eye._Config._Hook
local hook = {
  config = {},
}

--- @class Eye.C
local M = {
  label = label,
  layer = layer,
  hook = hook,
}

--- @param config Eye._Config._Label
--- @param parent? Eye._Config._Label
--- @return Eye._Config._Label
function label:proxy(config, parent)
  config = config or {}

  if not parent then
    if config.base.exclude then
      local include = {}
      for _, char in ipairs(self.config.base.include) do
        if not vim.list_contains(config.base.exclude, char) then
          table.insert(include, char)
        end
      end
      config.base.include = include
    end
    parent = self.config
  end

  return {
    base = setmetatable(config.base or {}, { __index = parent.base }),
    extmark = setmetatable(config.extmark or {}, { __index = parent.extmark }),
    highlight = setmetatable(config.highlight or {}, { __index = parent.highlight }),
    hook = setmetatable(config.hook or {}, { __index = parent.hook }),
  }
end

--- @param config Eye.Config.Label
--- @return Eye._Config._Label
function label:normalize(config)
  config = config or {}

  return {
    base = {
      exclude = config.exclude,
      include = config.include,
    },
    extmark = config.extmark,
    highlight = config.highlight,
    hook = {
      matched = config.matched,
      unmatched = config.unmatched,
    },
  }
end

--- @param config Eye.Config
--- @return Eye._Config._Hook
function hook:normalize(config)
  config = config or {}

  return {
    start = config.start,
    stop = config.stop,
    matched = config.matched,
    unmatched = config.unmatched,
  }
end

--- @param config Eye.Config.Layer
--- @return Eye._Config._Layer
function layer:normalize(config)
  return config or {} --[[@as Eye._Config._Layer]]
end

--- @param config Eye._Config._Layer
--- @param parent? Eye._Config._Layer
--- @return Eye._Config._Layer
function layer:proxy(config, parent)
  config = config or {}
  parent = parent or self.config
  return setmetatable(config or {}, { __index = parent or self.config })
end

--- @param config Eye._Config._Hook
--- @param parent? Eye._Config._Hook
--- @return Eye._Config._Hook
function hook:proxy(config, parent)
  return setmetatable(config or {}, { __index = parent or self.config })
end

--- @param config Eye._Config
--- @param parent? Eye._Config
--- @return Eye._Config
function M:proxy(config, parent)
  parent = parent or {}
  return {
    label = label:proxy(config.label, parent.label),
    layer = layer:proxy(config.layer, parent.layer),
    hook = hook:proxy(config.hook, parent.hook),
  }
end

--- @param config Eye.Config
--- @return Eye._Config
function M:normalize(config)
  return {
    label = label:normalize(config.label),
    hook = hook:normalize(config),
    layer = layer:normalize(config.layer),
  }
end

return M
