local M = {}

function M.setup()
  require("eye.plugin.search").setup()
end

--- @param config Eye.Config
function M.gaze(config)
  return require("eye.core").gaze(config)
end

return M
