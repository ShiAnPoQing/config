local core = require("my._atom._capture.core")
local id = 0

--- @class my._atom.Capturer.Opts: my._atom.Capturer.start.Opts

--- @class my._atom.Capturer.start.Opts
--- @field patch? fun(data: my.CmdAtom): my.CmdAtom|nil
--- @field filter? fun(data: my.CmdAtom): boolean

--- @class my._atom.Capturer
--- @field private running boolean|nil
--- @field private capture my.Atom
--- @field private patch? fun(data: my.CmdAtom): my.CmdAtom|nil
--- @field private filter? fun(data: my.CmdAtom): boolean
local M = {}
M.__index = M

--- @private
--- @param opts my._atom.Capturer.Opts?
function M:new(opts)
  vim.validate("opts", opts, "table", true)
  opts = opts or {}
  local o = setmetatable({}, self)
  o.capture = {
    atoms = {},
  }
  id = id + 1
  o.id = id
  vim.validate("opts.patch", opts.patch, "function", true)
  vim.validate("opts.filter", opts.filter, "function", true)
  o.patch = opts.patch
  o.filter = opts.filter
  return o
end

--- @param opts my._atom.Capturer.start.Opts?
function M:start(opts)
  vim.validate("opts", opts, "table", true)
  opts = opts or {}
  vim.validate("opts.patch", opts.patch, "function", true)
  vim.validate("opts.filter", opts.filter, "function", true)
  if self.running then
    vim.notify("my.atom.Capturer:start: Capturer had been running!", vim.log.levels.WARN)
    return
  end
  self.capture = {
    atoms = {},
  }
  self.running = true
  core.start(self, nil, {
    filter = opts.filter,
    patch = opts.patch,
  })
end

--- @param callback fun(capture: my.Atom)
function M:stop(callback)
  vim.validate("callback", callback, "function")
  if not self.running then
    vim.notify("my.atom.Capturer:stop: Capturer is not yet running!", vim.log.levels.WARN)
    return
  end
  self.running = nil
  core.stop(self, callback)
end

function M:get()
  return vim.tbl_deep_extend("force", self.capture, {})
end

return M
