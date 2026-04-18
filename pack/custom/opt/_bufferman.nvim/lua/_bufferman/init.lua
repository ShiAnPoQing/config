local M = {}

function M.setup(opt)
  require("bufferman.config").extend(opt)
end

M.bufferman = require("bufferman.core").toggle

return M
