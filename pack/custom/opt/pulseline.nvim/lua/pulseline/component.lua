--- @alias PulseLine.ConfigComponent fun(component: PulseLine.Component)|string

--- @alias PulseLine.Component._.Events table<vim.api.keyset.events, fun(ev: vim.api.keyset.create_autocmd.callback_args)[]>

--- @class PulseLine.Component._
--- @field children? PulseLine.Component._|string[]
--- @field events? PulseLine.Component._.Events
--- @field update? fun(component: PulseLine.Component)

--- @class PulseLine.Component
--- @field private _ PulseLine.Component._
local M = {}
M.__index = M

function M:new()
  local o = setmetatable({}, self)
  o._ = {}
  return o
end

--- @param config PulseLine.ConfigComponent
function M:Component(config)
  self._.children = self._.children or {}
  if type(config) == "function" then
    self._.update = config
    local component = M:new()
    table.insert(self._.children, component._)
    config(component)
  elseif type(config) == "string" then
    table.insert(self._.children, config)
  end
end

--- @param event vim.api.keyset.events
--- @param callback fun(ev: vim.api.keyset.create_user_command.command_args)
function M:on(event, callback)
  local events = self._.events or {}
  events[event] = events[event] or {}
  table.insert(events[event], callback)
  self._.events = events
end

return M
