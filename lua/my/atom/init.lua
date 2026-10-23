--- @class my.atom
--- @field _namespace my.atom._namespace
--- @field _registry my.atom._registry
--- @field _capture my.atom._capture
local M = vim._defer_require("my.atom", {
  _namespace = true,
  _registry = true,
  _capture = true,
})
local enabled

--- @class my.atom.Entry
--- @field buf integer
--- @field data vim.event.cmdatom.data

--- @class my.atom.start.Opts
--- @field id? integer

--- @param ns_id integer
--- @param opts? my.atom.start.Opts
--- @return integer
function M.start(ns_id, opts)
  vim.validate("ns_id", ns_id, "number")
  vim.validate("opts", opts, "table", true)
  opts = opts or {}
  if opts.id then
    vim.validate("opts.id", opts.id, "number")
  end
  M._namespace.create(ns_id)
  local id = opts.id or M._namespace.next_id(ns_id)
  M._capture.start(ns_id, id, opts)
  M._capture.watch(ns_id, id, function(capture)
    M._registry.register(ns_id, id, capture)
  end)
  return id
end

--- @param ns_id integer
--- @param id integer
function M.stop(ns_id, id)
  vim.validate("ns_id", ns_id, "number")
  vim.validate("id", id, "number")
  M._capture.stop(ns_id, id)
end

--- @param ns_id integer
function M.get(ns_id)
  vim.validate("ns_id", ns_id, "number")
  return M._registry.get(ns_id)
end

--- @param ns_id integer
--- @param id integer
--- @return my.atom.Entry[]
function M.get_by_id(ns_id, id)
  vim.validate("ns_id", ns_id, "number")
  vim.validate("id", id, "number")
  return M._registry.get_by_id(ns_id, id)
end

--- @param ns_id integer
--- @param id integer
function M.replay(ns_id, id)
  vim.validate("ns_id", ns_id, "number")
  vim.validate("id", id, "number")
  local atoms = M.get_by_id(ns_id, id)
  for _, atom in ipairs(atoms) do
    local data = atom.data
    vim.api.nvim_feedkeys(data.keys or data.lhs or "", data.keys and "n" or "m", false)
  end
end

--- @class my.atom.capture.Opts
--- @field filter? fun(any): boolean|nil

--- @param ns_id integer
--- @param count integer
--- @param opts? my.atom.capture.Opts
function M.capture(ns_id, count, opts)
  vim.validate("ns_id", ns_id, "number")
  vim.validate("count", count, "number")
  vim.validate("opts", opts, "table", true)
  opts = opts or {}
  if opts.filter then
    vim.validate("opts.filter", opts.filter, "function")
  end
end

--- @param ns_id integer
--- @param id integer
function M.del(ns_id, id)
  vim.validate("ns_id", ns_id, "number")
  vim.validate("id", id, "number")
  M._registry.remove(ns_id, id)
end

--- @param ns_id integer
function M.clear(ns_id)
  vim.validate("ns_id", ns_id, "number")
  M._registry.clear(ns_id)
end

--- @param enable boolean?
function M.enable(enable)
  vim.validate("enable", enable, "boolean", true)
  enable = enable ~= false
  if enable == enabled then
    return
  end
  enabled = enable
  if enable then
    M._capture.active()
  else
    M._capture.deactive()
  end
end

--- @param event "AtomBefore"|"AtomAfter"
--- @param callback fun(any): any
function M.on(event, callback)
  vim.validate("event", event, "string")
  if event == "AtomBefore" then
    M._capture.before(callback)
  elseif event == "AtomAfter" then
    return M._capture.after(callback)
  end
end

--- @param ns_id integer
--- @param id integer
--- @param callback fun(data:vim.event.cmdatom.data): vim.event.cmdatom.data
function M.patch(ns_id, id, callback)
  vim.validate("ns_id", ns_id, "number")
  vim.validate("id", id, "number")
  vim.validate("callback", callback, "function")
  M._capture.patch(ns_id, id, callback)
end

return M
