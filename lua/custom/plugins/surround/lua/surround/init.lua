local M = {}

function M.setup() end

M.surround_delete = function(mc)
  return require("surround.delete").surround_delete(mc)
end

M.surround_exchange = function(mc)
  return require("surround.exchange").surround_exchange(mc)
end

return M
