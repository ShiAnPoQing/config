--- @class my.atom._capture
--- @field core my.atom._capture.core
--- @field _capturer my.atom.Capturer
local M = vim._defer_require("my.atom._capture", {
  core = ..., --- @module 'my.atom._capture.core'
  _capturer = ..., --- @module 'my.atom._capture.capturer'
})

--- @param opts my.atom.Capturer.Opts?
function M.capturer(opts)
  if not M.core.is_enabled() then
    M.core.enable()
  end
  ---@diagnostic disable-next-line: invisible
  return M._capturer:new(opts)
end

return M
