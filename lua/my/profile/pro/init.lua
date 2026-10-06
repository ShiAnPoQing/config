--- @class my.profile.pro
--- @field _runtime my.profile.pro._runtime
--- @field _config my.profile.pro._config
--- @field motion my.profile.pro.motion
--- @field insert my.profile.pro.insert
--- @field change my.profile.pro.change
local M = vim._defer_require("my.profile.pro", {
  _runtime = ..., --- @module 'my.profile.pro._runtime'
  _config = ..., --- @module 'my.profile.pro._config'
  motion = ..., --- @module 'my.profile.pro.motion'
  insert = ..., --- @module 'my.profile.pro.insert'
  change = ..., --- @module 'my.profile.pro.change'
})

--- @param opts? my.profile.pro.Opts
function M.config(opts)
  M._config.config(opts)
end

return M
