--- @class my.atom._capture
local M = {}

local atom_modules = vim._defer_require("my.atom", {
  _namespace = ..., --- @module 'my.atom._namespace'
  _registry = ..., --- @module 'my.atom._registry'
})

--- @class my.atom._capture.Namespace.Id
--- @field started? boolean
--- @field capture? my.atom.data[]
--- @field patch? fun(data: vim.event.cmdatom.data): vim.event.cmdatom.data|nil
--- @field watch? fun(datas: my.atom.data[])
--- @field filter? fun(data: my.atom.data): boolean

--- @class my.atom._capture.Namespace
--- @field [integer] my.atom._capture.Namespace.Id

--- @type table<integer, my.atom._capture.Namespace>
local namespaces = {}
local listeners = {
  before = {},
  after = {},
}

--- @param ns_id integer
--- @return boolean
local function has_namespace(ns_id)
  return namespaces[ns_id] ~= nil
end

--- @param ns_id integer
--- @param id integer
--- @return boolean
local function has_namespace_id(ns_id, id)
  return has_namespace(ns_id) and namespaces[ns_id][id] ~= nil
end

--- @param ns_id integer
--- @param id integer
--- @param callback fun(data:vim.event.cmdatom.data): vim.event.cmdatom.data|nil
local function patch(ns_id, id, callback)
  if not has_namespace(ns_id) then
    return
  end
  namespaces[ns_id][id].patch = callback
end

--- @param ns_id integer
--- @param id integer
--- @param callback fun(datas: my.atom.data[])
local function watch(ns_id, id, callback)
  if not has_namespace(ns_id) then
    return
  end
  namespaces[ns_id][id].watch = callback
end

--- @param ns_id integer
--- @param id integer?
function M.del(ns_id, id)
  vim.validate("ns_id", ns_id, "number")
  vim.validate("id", id, "number", true)
  if id then
    namespaces[ns_id][id] = nil
  else
    namespaces[ns_id] = nil
  end
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
      for _, namespace in pairs(namespaces) do
        for _, session in pairs(namespace) do
          if session.started then
            if session.patch then
              data = session.patch(data)
            end
            local atom = {
              buf = ev.buf,
              data = data,
            }
            if not session.filter or (session.filter and session.filter(atom)) then
              if not session.capture then
                session.capture = {}
              end
              session.capture[#session.capture + 1] = atom
              if session.watch then
                session.watch(session.capture)
              end
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
--- @param opts? my.atom.create.Opts
--- @return integer
function M.create(ns_id, opts)
  vim.validate("ns_id", ns_id, "number")
  vim.validate("opts", opts, "table", true)
  opts = opts or {}
  if not atom_modules._namespace.has(ns_id) then
    atom_modules._namespace.create(ns_id)
  end
  local id = atom_modules._namespace.next_id(ns_id)
  if not has_namespace(ns_id) then
    namespaces[ns_id] = {}
  end
  namespaces[ns_id][id] = {}
  atom_modules._registry.register(ns_id, id, {})
  vim.validate("opts.watch", opts.watch, "function", true)
  vim.validate("opts.patch", opts.patch, "function", true)
  vim.validate("opts.filter", opts.filter, "function", true)
  if opts.watch then
    namespaces[ns_id][id].watch = watch
  end
  if opts.patch then
    namespaces[ns_id][id].patch = opts.patch
  end
  if opts.filter then
    namespaces[ns_id][id].filter = opts.filter
  end
  return id
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
--- @param id integer
--- @param opts my.atom.start.Opts?
function M.start(ns_id, id, opts)
  vim.validate("ns_id", ns_id, "number")
  vim.validate("id", id, "number")
  vim.validate("opts", opts, "table", true)
  opts = opts or {}
  namespaces[ns_id][id].started = true
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
  if not has_namespace_id(ns_id, id) then
    return
  end
  namespaces[ns_id][id].started = nil
end

return M
