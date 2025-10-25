local M = {}

M.match = function()
  local core = require("eye-track.keyword.core")
  core:init()
  core:match()
  return core.matches
end

return M
