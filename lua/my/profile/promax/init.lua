--- @class my.profile.promax
--- @field _runtime my.profile.promax._runtime
--- @field _config my.profile.promax._config
--- @field motion my.profile.promax.motion
--- @field insert my.profile.promax.insert
--- @field change my.profile.promax.change
local M = vim._defer_require("my.profile.promax", {
  _runtime = ..., --- @module 'my.profile.promax._runtime'
  _config = ..., --- @module 'my.profile.promax._config'
  motion = ..., --- @module 'my.profile.promax.motion'
  insert = ..., --- @module 'my.profile.promax.insert'
  change = ..., --- @module 'my.profile.promax.change'
})

--- @param opts my.profile.promax.Opts?
function M.config(opts)
  M._config.config(opts)
end

return M
