local submodules = {
  _namespace = true,
  _registry = true,
  _capture = true,
  _ui = true,
  ["repeat"] = true,
}

--- @class my.atom.data
--- @field buf integer
--- @field data vim.event.cmdatom.data

--- @class my.atom.create.Opts
--- @field patch? fun(data: vim.event.cmdatom.data): vim.event.cmdatom.data|nil
--- @field watch? fun(capture: my.atom.data[])
--- @field filter? fun(data: my.atom.data): boolean

--- @class my.atom.start.Opts
--- @field patch? fun(data: vim.event.cmdatom.data): vim.event.cmdatom.data|nil
--- @field watch? fun(capture: my.atom.data[])

--- @class my.atom.Namespace.Id
--- @field start fun(opts?: my.atom.start.Opts): integer
--- @field stop fun()
--- @field get fun(): my.atom.data[]
--- @field del fun()
--- @field replay fun()
--- @field show fun()

--- @class my.atom.Namespace
--- @field [integer] my.atom.Namespace.Id
--- @field create fun(opts: my.atom.create.Opts?): integer
--- @field start fun(id: integer, opts?: my.atom.start.Opts)
--- @field stop fun(id: integer)
--- @field get fun(): [integer, my.atom.data[]][]
--- @field get fun(id: integer): my.atom.data[]
--- @field del fun(id: integer?)
--- @field replay fun(id: integer)
--- @field show fun(id: integer?)

--- @class my.atom
--- @field _namespace my.atom._namespace
--- @field _registry my.atom._registry
--- @field _ui my.atom._ui
--- @field _capture my.atom._capture
--- @field repeat my.atom.repeat
--- @field [integer] my.atom.Namespace
local M = { _submodules = submodules }

--- @param ns_id integer
local function has_namespace(ns_id)
  return vim.tbl_contains(vim.tbl_values(vim.api.nvim_get_namespaces()), ns_id)
end

--- @param ns_id integer
--- @param id integer
local function has_namespace_id(ns_id, id)
  return M._registry.has(ns_id, id)
end

--- @param ns_id integer
--- @param id integer?
local function create_handle(key, ns_id, id)
  if not id and key == "create" then
    return function(opts)
      return M._capture.create(ns_id, opts)
    end
  end
  if key == "start" then
    return function(_id, opts)
      id = id or _id
      return M._capture.start(ns_id, id, opts)
    end
  end
  if key == "stop" then
    return function(_id)
      id = id or _id
      return M._capture.stop(ns_id, id)
    end
  end
  if key == "get" then
    return function(_id)
      id = id or _id
      return M._capture.get(ns_id, id)
    end
  end
  if key == "del" then
    return function(_id)
      id = id or _id
      return M._capture.del(ns_id, id)
    end
  end
  if key == "replay" then
    return function(_id)
      id = id or _id
      return M.replay(ns_id, id)
    end
  end
  if key == "show" then
    return function(_id)
      id = id or _id
      M._ui.open(ns_id)
    end
  end
end

--- @param ns_id integer
--- @param id integer
local function create_namespace_id_proxy(ns_id, id)
  return setmetatable({}, {
    __index = function(_, k)
      return create_handle(k, ns_id, id)
    end,
  })
end

--- @param ns_id integer
--- @return my.atom.Namespace
local function create_namespce_proxy(ns_id)
  return setmetatable({}, {
    __index = function(_, k)
      if type(k) == "number" then
        if not has_namespace_id(ns_id, k) then
          vim.notify(string.format("my.atom[%d]: id %d does not exist!", ns_id, k), vim.log.levels.WARN)
          return {}
        end
        return create_namespace_id_proxy(ns_id, k)
      end
      return create_handle(k, ns_id)
    end,
  })
end

setmetatable(M, {
  ---@param t table<string, any>
  ---@param k string
  __index = function(t, k)
    if type(k) == "number" then
      if not has_namespace(k) then
        vim.notify(string.format("my.atom: namespace %d does not exist!", k), vim.log.levels.WARN)
        return {}
      end
      return create_namespce_proxy(k)
    end
    if not submodules[k] then
      return
    end
    local name = string.format("%s.%s", "my.atom", k)
    t[k] = require(name)
    return t[k]
  end,
})

local enabled

--- @param ns_id integer
--- @param id integer
function M.replay(ns_id, id)
  vim.validate("ns_id", ns_id, "number")
  vim.validate("id", id, "number")
  local captures = M._registry.get(ns_id, id)
  for _, capture in ipairs(captures) do
    local data = capture.data
    vim.api.nvim_feedkeys(data.keys or data.lhs or "", data.keys and "n" or "m", false)
  end
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
    vim.api.nvim_create_user_command("AtomShow", function(ev)
      local name = ev.args
      local ns_id = vim.api.nvim_get_namespaces()[name]
      if not ns_id then
        return
      end
      my.atom[ns_id].show()
    end, {
      nargs = 1,
    })
  else
    M._capture.deactive()
    vim.api.nvim_del_user_command("AtomShow")
  end
end

--- @param event "AtomBefore"|"AtomAfter"
--- @param callback fun(ev: any)
function M.on(event, callback)
  vim.validate("event", event, "string")
  vim.validate("callback", callback, "function")
  if event == "AtomBefore" then
    M._capture.before(callback)
  elseif event == "AtomAfter" then
    M._capture.after(callback)
  end
end

--- @return boolean
function M.is_enabled()
  return enabled
end

return M
