--- @class my.atom._capture
local M = {}

local atom_modules = vim._defer_require("my.atom", {
  _namespace = ..., --- @module 'my.atom._namespace'
  _registry = ..., --- @module 'my.atom._registry'
})

local capture_namespaces = {}
local listeners = {
  before = {},
  after = {},
}

--- @param ns_id integer
--- @param id integer
--- @param callback fun(data:vim.event.cmdatom.data): vim.event.cmdatom.data
local function patch(ns_id, id, callback)
  local namespace = capture_namespaces[ns_id]

  if not namespace[id] then
    return
  end

  local session = namespace[id]
  if not session.patch then
    session.patch = {}
  end
  table.insert(session.patch, callback)
end

--- @param ns_id integer
--- @param id integer
--- @param callback fun(any)
local function watch(ns_id, id, callback)
  if not capture_namespaces[ns_id] then
    return
  end
  local session = capture_namespaces[ns_id][id]
  if not session.watch then
    session.watch = {}
  end
  table.insert(session.watch, callback)
end

--- @param ns_id integer
--- @param id integer?
function M.del(ns_id, id)
  vim.validate("ns_id", ns_id, "number")
  vim.validate("id", id, "number", true)
  atom_modules._registry.del(ns_id, id)
end

local cmdatom_id

function M.active()
  if cmdatom_id then
    return
  end

  cmdatom_id = vim.api.nvim_create_autocmd("CmdAtom", {
    callback = function(ev)
      local data = ev.data --[[@as vim.event.cmdatom.data]]
      for _, listener in ipairs(listeners.before) do
        listener(data)
      end
      for _, namespace in pairs(capture_namespaces) do
        for _, session in pairs(namespace) do
          if session.started then
            for _, cb in ipairs(session.patch or {}) do
              data = cb(data)
            end
            if not session.capture then
              session.capture = {}
            end
            session.capture[#session.capture + 1] = {
              buf = ev.buf,
              data = data,
            }
            for _, cb in ipairs(session.watch or {}) do
              cb(session.capture)
            end
          end
        end
      end
      for _, listener in ipairs(listeners.after) do
        listener(data)
      end
    end,
  })
end

function M.deactive()
  if not cmdatom_id then
    return
  end
  vim.api.nvim_del_autocmd(cmdatom_id)
  cmdatom_id = nil
end

--- @param callback fun()
function M.before(callback)
  table.insert(listeners.before, callback)
end

--- @param callback fun()
function M.after(callback)
  table.insert(listeners.after, callback)
end

--- @param ns_id integer
--- @return [integer, my.atom.data[]][]
--- @overload fun(ns_id: integer, id: integer): my.atom.data[]
function M.get(ns_id, id)
  vim.validate("ns_id", ns_id, "number")
  vim.validate("id", id, "number", true)
  if id then
    return atom_modules._registry.get(ns_id, id)
  end
  local results = {}
  for i, result in pairs(atom_modules._registry.get(ns_id) or {}) do
    table.insert(results, { i, result })
  end
  return results
end

--- @param ns_id integer
--- @param id integer?
--- @param opts my.atom.start.Opts?
function M.start(ns_id, id, opts)
  vim.validate("ns_id", ns_id, "number")
  vim.validate("opts", opts, "table", true)
  opts = opts or {}
  atom_modules._namespace.create(ns_id)
  id = id or atom_modules._namespace.next_id(ns_id)
  vim.validate("id", id, "number")
  if not capture_namespaces[ns_id] then
    capture_namespaces[ns_id] = {}
  end
  capture_namespaces[ns_id][id] = { started = true }
  vim.validate("opts.watch", opts.watch, "function", true)
  vim.validate("opts.patch", opts.patch, "function", true)
  if opts.watch then
    watch(ns_id, id, opts.watch)
  end
  if opts.patch then
    patch(ns_id, id, opts.patch)
  end
  watch(ns_id, id, function(capture)
    atom_modules._registry.register(ns_id, id, capture)
  end)
  return id
end

--- @param ns_id integer
--- @param id integer
function M.stop(ns_id, id)
  vim.validate("ns_id", ns_id, "number")
  vim.validate("id", id, "number")
  if not capture_namespaces[ns_id] then
    return
  end
  capture_namespaces[ns_id][id] = nil
end

return M
