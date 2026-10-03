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
function M.defer_require(root, mod)
  return setmetatable({ _submodules = mod }, {
    ---@param t table<string, any>
    ---@param k string
    __index = function(t, k)
      if not mod[k] then
        return
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
