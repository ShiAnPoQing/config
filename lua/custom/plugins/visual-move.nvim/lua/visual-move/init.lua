local M = {}

function M.setup() end

--- @type fun(dir: "left"|"right")
M.visual_move = function(dir)
  require("visual-move.base-move").visual_move(dir)
end

--- @type fun(dir: "left"|"right")
M.visual_start_end_move = function(dir)
  require("visual-move.start-end-move").visual_start_end_move(dir)
end

return M
