--- @class my.keymap
--- @field keys table<string, string>
local M = vim._defer_require("my.keymap", {
  keys = ..., --- @module 'my.keymap.keys'
})

return M
