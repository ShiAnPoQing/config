--- @class my.util
local M = vim._defer_require("my.util", {})

function M.try(fn, ...)
  if type(fn) == "function" then
    return fn(...)
  end
end

function M.get_mode()
  return vim.api.nvim_get_mode().mode
end

--- @param root string
--- @param mod table<string, boolean|string|fun(t: table): any>
function M.defer_require(root, mod)
  return setmetatable({ _submodules = mod }, {
    ---@param t table<string, any>
    ---@param k string
    __index = function(t, k)
      if not mod[k] then
        return
      end

      if type(mod[k]) == "function" then
        t[k] = mod[k](t)
        return t[k]
      end

      -- alias
      if type(mod[k]) == "string" then
        ---@diagnostic disable-next-line: cast-local-type
        k = mod[k]
      end

      local name = string.format("%s.%s", root, k)
      t[k] = require(name)
      return t[k]
    end,
  })
end

return M
