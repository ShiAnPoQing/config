--- @class my.env.pro
--- @field motion my.env.pro.motion
--- @field insert my.env.pro.insert
--- @field change my.env.pro.change
local M = vim._defer_require(..., {
  motion = ..., --- @module 'my.env.pro.motion'
  insert = ..., --- @module 'my.env.pro.insert'
  change = ..., --- @module 'my.env.pro.change'
})

return M
