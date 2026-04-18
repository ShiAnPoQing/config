local M = {}

function M.call(callback, ...)
  if type(callback) == "function" then
    return callback(...)
  end
end

return M
