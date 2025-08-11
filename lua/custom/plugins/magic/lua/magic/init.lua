local M = {}

function M.setup(opts) end

M.magic_keyword = require("magic.magic-keyword").magic_keyword
M.magic_line = require("magic.magic-line").magic_line
M.magic_line_start_end = require("magic.magic-line-start-end").magic_line_start_end
M.magic_screen = require("magic.magic-screen").magic_screen
M.magic_move_line = require("magic.magic-move-line").magic_move_line

return M
