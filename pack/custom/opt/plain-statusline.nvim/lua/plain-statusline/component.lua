local U = require("plain-statusline.utils")

--- @class PlainStatusline._Component
--- @field private _ PlainStatusline.Component
--- @field children PlainStatusline._Component[]
--- @field parent PlainStatusline._Component?
--- @field event_update boolean
--- @field redraw_update boolean
--- @field statusline string
local M = {}
M.__index = M

--- @param self PlainStatusline._Component
--- @param update? string|PlainStatusline.Component.Autocmd|(string|PlainStatusline.Component.Autocmd)[]
local function register_event(self, update)
  local events = {}
  local callback, pattern
  if type(update) == "string" then
    events[#events + 1] = update
  elseif type(update) == "table" then
    if #update > 1 then
      for _, v in ipairs(update) do
        if type(v) == "string" then
          table.insert(events, v)
        elseif type(v) == "table" then
          if type(v.callback) == "function" then
            callback = v.callback
            pattern = v.pattern
            events[#events + 1] = v[1]
            table.insert(events, v[1])
          end
        end
      end
    else
      if type(update.callback) == "function" then
        callback = update.callback
        pattern = update.pattern
        events[#events + 1] = update[1]
      end
    end
  end

  callback = callback or function()
    self:ensure_update()
  end
  if type(callback) ~= "function" then
    error("callback must be a function")
    return
  end
  if #events == 0 then
    return
  end
  vim.api.nvim_create_autocmd(events, {
    pattern = pattern,
    callback = function(args)
      ---@diagnostic disable-next-line: invisible
      callback(self._, args)
    end,
  })
end

function M:ensure_update()
  self.event_update = true
  vim.schedule(function()
    if self.event_update and not self.redraw_update then
      self.redraw_update = true
      vim.cmd("redrawstatus")
    end
  end)
end

--- @param component PlainStatusline.Component
--- @param parent PlainStatusline._Component?
function M:new(component, parent)
  local o = setmetatable({ _ = setmetatable(component, { __index = parent and parent._ or {} }) }, self)
  o:init()
  o.parent = parent
  o.statusline = ""
  o.children = {}
  o._.ensure_update = function()
    o:ensure_update()
  end
  register_event(o, o._.update)
  for _, child in ipairs(o._) do
    if type(child) == "table" then
      o.children[#o.children + 1] = M:new(child, o)
    end
  end
  return o
end

function M:init()
  if not self:condition() then
    return
  end
  U.try(self._.init, self._)
end

function M:provider()
  if not self:condition() or self:update() ~= true then
    return self.statusline
  end

  local provide = self._.provider
  if type(self._.provider) == "function" then
    provide = self._.provider(self._)
  end
  if type(provide) ~= "string" and type(provide) ~= "number" then
    provide = ""
  end
  local hl = self:get_hl()
  if hl then
    provide = hl .. provide .. "%*"
  end
  for _, child in ipairs(self.children) do
    provide = provide .. child:provider()
  end

  self.statusline = provide
  return self.statusline
end

function M:update()
  if self.redraw_update then
    self.redraw_update = false
    return true
  end
  if self.event_update then
    self.event_update = false
    return true
  end
  if type(self._.update) == "function" then
    return self._.update(self._)
  end
  if type(self._.update) == "string" then
    return false
  end
  return true
end

function M:condition()
  if type(self._.condition) == "function" then
    return self._.condition(self._)
  end
  return true
end

local function get_hl(hl, ...)
  if type(hl) == "function" then
    hl = hl(...)
  end
  if type(hl) == "string" then
    return "%#" .. hl .. "#"
  end
end

function M:get_hl()
  return get_hl(rawget(self._, "hl"), self._) or get_hl(self._.hl, self._)
end

return M
