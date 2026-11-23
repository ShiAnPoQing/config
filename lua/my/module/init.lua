--- @class my.module
local M = {}

--- @class my.submodule.config
--- @field scope? boolean

--- @alias my.submodules table<string, true|string|my.submodule.config|fun(t: table): any>

--- @param submodules my.submodules
--- @param key string
--- @return true|string|my.submodule.config|fun(t: table): any
local function get_module_config(submodules, key)
  local config = submodules[key]
  if type(config) == "string" then
    config = submodules[config]
  end
  return config
end

--- @param scope integer
--- @param mod table
--- @return table
function M.wrap_with_scope(scope, mod)
  local submodules = mod._submodules or {}
  return setmetatable({}, {
    __index = function(t, k)
      if not submodules[k] then
        local value = mod[k]
        if type(value) == "function" then
          t[k] = function(...)
            return value(scope, ...)
          end
          return t[k]
        end
        return value
      end
      local config = get_module_config(submodules, k)
      if config.scope then
        t[k] = M.wrap_with_scope(scope, mod[k])
        return t[k]
      end
    end,
  })
end

--- @param modules my.submodules
--- @param name string
--- @return string
local function get_module_name(modules, name)
  local function get_name(n)
    local config = modules[n]
    if type(config) == "string" then
      return get_name(config)
    else
      return n
    end
  end
  return get_name(name)
end

--- @param root string
--- @param submodules my.submodules
function M.defer_require(root, submodules)
  vim.validate("root", root, "string")
  vim.validate("submodules", submodules, "table")
  return setmetatable({ _submodules = submodules }, {
    ---@param t table<string, any>
    ---@param k string
    __index = function(t, k)
      k = get_module_name(submodules, k)
      if not submodules[k] then
        return
      end

      if type(submodules[k]) == "function" then
        t[k] = submodules[k](t)
        return t[k]
      end

      local name = string.format("%s.%s", root, k)
      t[k] = require(name)
      return t[k]
    end,
  })
end

return M
