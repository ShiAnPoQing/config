--- @class my.win
local M = {}
setmetatable(M, {
  __index = function(_, k)
    if type(k) == "number" then
      return setmetatable({}, {
        __index = function(_, key)
          if type(M[key]) == "function" then
            return function(...)
              return M[key](...)
            end
          end
        end,
      })
    end
  end,
})

return M
