local Cfg = require("_eye.core.config")
local Session = require("_eye.core.session")

--- @class _Eye.Active.Opts
--- @field config _Eye.Active.Config
--- @field state _Eye.Session.State

--- @class _Eye.Active
--- @field state _Eye.Session.State
--- @field config _Eye.Active.Config
local M = {}
M.__index = M

--- @param opts _Eye.Active.Opts
function M:new(opts)
  return setmetatable({
    config = opts.config,
    state = opts.state,
  } --[[@as _Eye.Active]], self)
end

--- @param config? _Eye.Active.Config
--- @return _Eye.Active
function M:active(config)
  config = Cfg.merge_active_config(config or {})
  local state = Session.run(self.state, {
    update = config.update,
    actions = config.actions,
    active = config.active,
    press = config.press,
    flush = config.flush,
    complete = config.complete,
    cancel = config.cancel,
  })
  return M:new({
    config = config,
    state = state,
  })
end

return M
