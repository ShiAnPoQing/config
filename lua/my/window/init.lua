--- @class my.window
--- @field float my.window.float
local M = vim._defer_require("my.window", {
  float = ..., --- @module 'my.window.float'
})

return M
