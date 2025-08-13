local M = {}

function M.setup(opts) end

M.magic_keyword = function(opts)
  return require("magic.magic-keyword").magic_keyword(opts)
end

M.magic_line = function(opts)
  return require("magic.magic-line").magic_line(opts)
end

M.magic_line_start_end = function(opts)
  return require("magic.magic-line-start-end").magic_line_start_end(opts)
end

M.magic_screen = function(opts)
  return require("magic.magic-screen").magic_screen(opts)
end

M.magic_move_line = function(opts)
  return require("magic.magic-move-line").magic_move_line(opts)
end

return M
