--- @class (private) my.atom._registry
local M = {}

local atoms = {}

--- @param ns_id integer
--- @param id integer
--- @param source any
function M.register(ns_id, id, source)
  if not atoms[ns_id] then
    atoms[ns_id] = {}
  end
  atoms[ns_id][id] = source
end

--- @param ns_id integer
--- @param id integer?
--- @return any
function M.get(ns_id, id)
  if not id then
    return atoms[ns_id]
  end
  return atoms[ns_id][id]
end

--- @param ns_id integer
--- @param id integer?
function M.del(ns_id, id)
  if not id then
    atoms[ns_id] = nil
    return
  end
  atoms[ns_id][id] = nil
end

--- @param ns_id integer
--- @param id integer?
--- @return boolean
function M.has(ns_id, id)
  if not id then
    return atoms[ns_id] ~= nil
  end
  return atoms[ns_id][id] ~= nil
end

return M
