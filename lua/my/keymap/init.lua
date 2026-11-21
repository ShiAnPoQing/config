--- @class my.keymap
--- @field keys table<string, string>
local M = vim._defer_require("my.keymap", {
  keys = ..., --- @module 'my.keymap.keys'
})

--- @class my.keymap.spec

function M.set() end

function M.del() end

return M
