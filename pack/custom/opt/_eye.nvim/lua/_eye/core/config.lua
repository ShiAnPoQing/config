local M = {}
local U = require("_eye.core.utils")

-- stylua: ignore
local include = { "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z" }

--- @type _Eye.Config
local default_config = {
  build = function(total)
    local depth, remain = U.compute(#include, total)
    --- @type _Eye.Build.Queue
    local queue1 = { { include = vim.list_slice(include, remain + 1) } }
    --- @type _Eye.Build.Queue
    local queue2 = { { include = vim.list_slice(include, 1, remain) } }
    for _ = 1, depth - 2 do
      table.insert(queue1, { include = include })
    end
    for _ = 1, depth - 1 do
      table.insert(queue2, { include = include })
    end
    --- @type _Eye.Config.Build
    local build = {
      queue1,
      queue2,
      get = function(ctx)
        return ctx.include[math.random(#ctx.include)]
      end,
    }
    return build
  end,
}

--- @param ... _Eye.Config[]
--- @return _Eye.Config
function M.merge_label_config(...)
  local config = vim.tbl_deep_extend("force", default_config, ...)
  return config
end

--- @type _Eye.Active.Config
local default_active_config = {
  actions = {
    ["<bs>"] = function(ctx)
      ctx.rollback()
    end,
  },
}

--- @param ... _Eye.Active.Config[]
--- @return _Eye.Active.Config
function M.merge_active_config(...)
  local config = vim.tbl_deep_extend("force", default_active_config, ...)
  local actions = {}
  for key, value in pairs(config.actions) do
    local lower_key = tostring(key):lower()
    if lower_key == "<c-j>" then
      lower_key = "<nl>"
    end
    actions[lower_key] = value
  end
  config.actions = actions
  return config
end

return M
