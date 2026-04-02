local M = {}

function M.try(fn, ...)
  if type(fn) == "function" then
    return fn(...)
  end
end

return M
