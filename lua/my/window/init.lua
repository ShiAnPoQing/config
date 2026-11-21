--- @class my.window
--- @field float my.window.float
--- @field float fun(file: string)
local M = vim._defer_require("my.window", {
  float = ..., --- @module 'my.window.float'
})

return M
