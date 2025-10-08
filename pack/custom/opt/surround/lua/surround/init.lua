local M = {}

function M.setup() end

M.delete = function(mc)
  return require("surround.delete").delete(mc)
end

M.exchange = function(mc)
  return require("surround.exchange").exchange(mc)
end

return M
