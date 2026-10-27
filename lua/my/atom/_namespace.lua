--- @class (private) my.atom._namespace
local M = {}
local namespaces = {}

--- @param ns_id integer
function M.create(ns_id)
  if not namespaces[ns_id] then
    namespaces[ns_id] = { last_id = 0 }
  end
end

--- @param ns_id integer
--- @return boolean
function M.has(ns_id)
  if not namespaces[ns_id] then
    return false
  end
  return true
end

--- @param ns_id integer
--- @param id integer
--- @return boolean
function M.has_id(ns_id, id)
  if not namespaces[ns_id] then
    return false
  end
  return namespaces[ns_id][id] ~= nil
end

--- @param ns_id integer
--- @return integer
function M.next_id(ns_id)
  local ns = namespaces[ns_id]
  if not ns then
    M.create(ns_id)
    return M.next_id(ns_id)
  end
  local next_id = ns.last_id + 1
  ns.last_id = next_id
  return next_id
end

return M
