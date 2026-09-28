--- @class my.util
local M = vim._defer_require("my.util", {})

function M.try(fn, ...)
  if type(fn) == "function" then
    return fn(...)
  end
end

return M
