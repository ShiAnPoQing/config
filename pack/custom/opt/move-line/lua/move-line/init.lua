local M = {}

--- @class MoveLineOpts

--- @param opts MoveLineOpts
function M.setup(opts) end

M.move_line = require("move-line.move-line").move_line

return M
