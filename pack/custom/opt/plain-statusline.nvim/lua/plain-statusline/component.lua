--- @class PlainStatusline._Component
--- @field _ PlainStatusline.Component
--- @field statusline string
--- @field children PlainStatusline._Component[]
--- @field parent PlainStatusline._Component?
--- @field pending_event boolean|nil
--- @field pending_init boolean|nil
--- @field tag "event"|"default"
local M = {}
M.__index = M

--- @param component PlainStatusline.Component
--- @param event string
--- @param opts PlainStatusline.Component.EventConfig
local function create_autocmd(component, event, opts)
  if type(event) ~= "string" then
    return
  end
  if opts.callback and type(opts.callback) ~= "function" then
    return
  end
  if opts.pattern and type(opts.pattern) ~= "string" and type(opts.pattern) ~= "table" then
    return
  end
  vim.api.nvim_create_autocmd(event, {
    pattern = opts.pattern,
    callback = function(args)
      opts.callback(component, args)
    end,
  })
end

--- @param self PlainStatusline._Component
--- @param event? PlainStatusline.Component.Event
local function register_event(self, event)
  local function work(source, opts)
    if type(source) == "string" then
      create_autocmd(self._, source, opts)
      return
    end
    if type(source) ~= "table" then
      return
    end
    for _, value in ipairs(source) do
      work(value, vim.tbl_extend("force", opts, source))
    end
  end
  work(event, {
    callback = function()
      self:redraw()
    end,
  })
end

--- @param component PlainStatusline.Component
--- @param parent PlainStatusline._Component?
function M:new(component, parent)
  local o = setmetatable({ _ = setmetatable(component, { __index = parent and parent._ or {} }) }, self)
  o:init(parent)
  return o
end

--- @param parent PlainStatusline._Component?
function M:init(parent)
  self.parent = parent
  self.statusline = ""
  self.children = {}
  self._.redraw = function()
    self:redraw()
  end

  if self._.event == nil then
    self.tag = "default"
  else
    self.tag = "event"
    register_event(self, self._.event)
  end

  if type(self._.init) == "function" then
    self.pending_init = true
  end

  for _, child in ipairs(self._) do
    if type(child) == "table" then
      self.children[#self.children + 1] = M:new(child, self)
    end
  end
end

function M:eval()
  if not self:condition() then
    return ""
  end
  self:compute()
  local provide = self:provider()
  for _, child in ipairs(self.children) do
    provide = provide .. child:eval()
  end
  self.statusline = provide
  return self.statusline
end

function M:compute()
  local function update()
    if type(self._.update) == "function" then
      self._:update()
    end
  end

  local function init()
    if type(self._.init) == "function" then
      self._:init()
    end
  end

  if self.pending_init then
    self.pending_init = nil
    init()
    return
  end

  if self.tag == "event" then
    if self.pending_event then
      self.pending_event = nil
      update()
    end
  elseif self.tag == "default" then
    update()
  end
end

function M:provider()
  local provide = self._.provider
  if type(self._.provider) == "function" then
    provide = self._.provider(self._)
  end
  if type(provide) ~= "string" and type(provide) ~= "number" then
    provide = ""
  end
  local hl = self:get_hl_item()
  if hl then
    provide = hl .. provide .. "%*"
  end
  return provide
end

function M:condition()
  if type(self._.condition) == "function" then
    return self._:condition()
  end
  return true
end

local function get_hl_item(hl, ...)
  if type(hl) == "function" then
    hl = hl(...)
  end
  if type(hl) == "string" then
    return "%#" .. hl .. "#"
  end
end

function M:get_hl_item()
  return get_hl_item(rawget(self._, "hl"), self._) or get_hl_item(self._.hl, self._)
end

function M:redraw()
  self.pending_event = true
  vim.schedule(function()
    if self.pending_event then
      vim.cmd("redrawstatus")
    end
  end)
end

return M
