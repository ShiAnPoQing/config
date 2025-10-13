local M = {}

--- @class NeoBufferOptions

--- @param opts NeoBufferOptions
function M.setup(opts)
  M.buffers = require("neo-buffer.core").buffers
end

return M
