--- @class PlainStatusline._Component
--- @field _ PlainStatusline.Component
--- @field status string
--- @field children PlainStatusline._Component[]
--- @field parent PlainStatusline._Component?
--- @field pending_event vim.api.keyset.create_autocmd.callback_args[]
--- @field pending_init boolean|nil
--- @field highlights table<string, boolean>
local M = {
  highlights = {},
}
M.__index = M

local U = require("plain-statusline.utils")

--- @param event string
--- @param opts vim.api.keyset.create_autocmd
local function create_autocmd(event, opts)
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
    callback = opts.callback,
  })
end

--- @param component PlainStatusline.Component
--- @param parent PlainStatusline._Component?
function M:new(component, parent)
  local o = setmetatable({ _ = setmetatable(component, { __index = parent and parent._ or {} }) }, self)
  o:init(parent)
  return o
end

function M:_register_event()
  if type(self._.event) ~= "table" then
    return
  end

  for event_name, value in pairs(self._.event) do
    local callback, pattern
    if type(value) == "table" then
      pattern = value.pattern
      callback = value.callback
    elseif type(value) == "function" then
      callback = value
    end
    create_autocmd(event_name, {
      pattern = pattern,
      callback = function(args)
        U.try(callback, self._, args)
        self:redraw(args)
      end,
    })
  end
end

--- @param parent PlainStatusline._Component?
function M:init(parent)
  self.parent = parent
  self.status = ""
  self.children = {}
  self.pending_event = {}
  self:_register_event()
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
    self.status = ""
    return self.status
  end
  self:update()
  local provide = self:provider()
  for _, child in ipairs(self.children) do
    provide = provide .. child:eval()
  end
  ---@diagnostic disable-next-line: assign-type-mismatch
  self.status = provide
  return self.status
end

function M:update()
  if self.pending_init then
    self.pending_init = nil
    U.try(self._.init, self._)
  end
  if #self.pending_event > 0 then
    U.try(self._.update, self._, self.pending_event)
    self.pending_event = {}
  else
    U.try(self._.update, self._, {})
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

--- @param opts vim.api.keyset.highlight
local function set_hl(opts)
  local key_parts = {}
  for k, v in pairs(opts) do
    table.insert(key_parts, k .. "_" .. tostring(v))
  end
  table.sort(key_parts)
  local key = "PlainStatusline_" .. table.concat(key_parts, "_")
  key = key:gsub("#", "")

  if not M.highlights[key] then
    vim.api.nvim_set_hl(0, key, opts)
    M.highlights[key] = true
  end

  return key
end

local function get_hl_item(hl, ...)
  if type(hl) == "function" then
    hl = hl(...)
  end
  if type(hl) == "table" then
    hl = set_hl(hl)
  end
  if type(hl) == "string" then
    return "%#" .. hl .. "#"
  end
end

function M:get_hl_item()
  return get_hl_item(rawget(self._, "hl"), self._) or get_hl_item(self._.hl, self._)
end

--- @param args vim.api.keyset.create_autocmd.callback_args
function M:redraw(args)
  self.pending_event[#self.pending_event + 1] = args
  vim.schedule(function()
    if #self.pending_event > 0 then
      vim.cmd("redrawstatus")
    end
  end)
end

return M
