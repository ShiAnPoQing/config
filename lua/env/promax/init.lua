--- @class my.env.promax
--- @field motion my.env.promax.motion
--- @field insert my.env.promax.insert
--- @field change my.env.promax.change
local M = vim._defer_require(..., {
  motion = ..., --- @module 'my.env.promax.motion'
  insert = ..., --- @module 'my.env.promax.insert'
  change = ..., --- @module 'my.env.promax.change'
})
return M
