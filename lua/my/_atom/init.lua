--- @class my._atom
--- @field private _capture my._atom._capture
--- @field private _namespace my._atom._namespace
--- @field private _menu my._atom._menu
--- @field repeat my._atom.repeat
--- @field marco my._atom.marco
local M = vim._defer_require("my._atom", {
  _capture = ..., ---@module 'my._atom._capture'
  _namespace = ..., ---@module 'my._atom._namespace'
  _menu = ..., ---@module 'my._atom._menu'
  ["repeat"] = ..., ---@module 'my._atom.repeat'
  marco = ..., ---@module 'my._atom.marco'
})

--- @class my.CmdAtom:vim.event.cmdatom.data
--- @field buf integer

--- @class my.Atom
--- @field atoms my.CmdAtom[]

--- @param opts my._atom.Capturer.Opts?
--- @return my._atom.Capturer
function M.capturer(opts)
  return M._capture.capturer(opts)
end

--- @param event "CmdAtomBefore"|"CmdAtomAfter"
--- @param callback fun(ev: vim.api.keyset.create_autocmd.callback_args)
--- @return integer
function M.on(event, callback)
  vim.validate("event", event, "string")
  vim.validate("callback", callback, "function")
  if not vim.list_contains({ "CmdAtomBefore", "CmdAtomAfter" }, event) then
    vim.notify(string.format("my.atom.on: not such event %s!", event), vim.log.levels.WARN)
    return -1
  end
  if not M._capture.core.is_enabled() then
    M._capture.core.enable()
  end
  local id = vim.api.nvim_create_autocmd("User", {
    pattern = event,
    callback = function(ev)
      callback(ev)
    end,
  })
  return id
end

--- @param keys string
--- @param callback fun(atom: my.Atom)
function M.feed(keys, callback)
  vim.validate("keys", keys, "string")
  vim.validate("callback", callback, "function")
  local Capturer = M.capturer()
  Capturer:start()
  vim.api.nvim_feedkeys(keys, "n", false)
  Capturer:stop(function(atom)
    callback(atom)
  end)
end

--- @param ns_id integer
--- @param id integer
function M.replay(ns_id, id)
  if not M._namespace.has(ns_id, id) then
    return
  end
  local Atom = M._namespace.get(ns_id, id) --[[@as my.Atom]]
  for _, atom in ipairs(Atom.atoms) do
    vim.api.nvim_feedkeys(atom.keys or atom.lhs or "", atom.keys and "n" or "m", false)
  end
end

--- @param ns_id integer
--- @param atom my.Atom
--- @return integer
function M.create(ns_id, atom)
  vim.validate("ns_id", ns_id, "number")
  vim.validate("atom", atom, "table")
  M._namespace.create(ns_id)
  local id = M._namespace.next_id(ns_id)
  M._namespace.set(ns_id, id, atom)
  return id
end

--- @param ns_id integer
--- @return [integer, my.Atom][]
--- @overload fun(ns_id: integer, id: integer): my.Atom
function M.get(ns_id, id)
  vim.validate("ns_id", ns_id, "number")
  vim.validate("id", id, "number", true)
  if not id then
    local resource = M._namespace.get(ns_id, id) --[[@as table<integer, my.Atom>]]
    local results = {} --[[@as [integer, my.Atom][]]
    for _id, atom in pairs(resource or {}) do
      table.insert(results, { _id, atom })
    end
    return results
  end
  return M._namespace.get(ns_id, id) --[[@as my.Atom]]
end

--- @param ns_id integer
--- @param id integer?
function M.del(ns_id, id)
  vim.validate("ns_id", ns_id, "number")
  vim.validate("id", id, "number", true)
  M._namespace.del(ns_id, id)
end

--- @param ns_id integer
--- @param opts? my._atom._menu.Opts
function M.show(ns_id, opts)
  M._menu.open(ns_id, opts)
end

vim.api.nvim_create_user_command("AtomShow", function(ev)
  local name = ev.args
  local ns_id = vim.api.nvim_get_namespaces()[name]
  if not ns_id then
    return
  end
  my._atom.show(ns_id)
end, {
  nargs = 1,
})

return M
