local M = {}
local Window = require("buffer.window")

function M.buffer()
  Window.toggle({})
end

---@param config BufferConfig
function M.init(config)
  Window.init(config.win)
end

return M
