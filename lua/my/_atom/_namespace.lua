--- @class my._atom._namespace
local M = {}
local namespaces = {}

--- @param ns_id integer
function M.create(ns_id)
  vim.validate("ns_id", ns_id, "number")
  if not namespaces[ns_id] then
    namespaces[ns_id] = {
      next_id = 1,
    }
  end
end

--- @param ns_id integer
--- @return integer
function M.next_id(ns_id)
  vim.validate("ns_id", ns_id, "number")
  local namespace = namespaces[ns_id]
  if not namespace then
    return -1
  end
  local id = namespace.next_id
  namespace.next_id = namespace.next_id + 1
  return id
end

--- @param ns_id integer
--- @param id integer
--- @param source any
--- @return boolean
function M.set(ns_id, id, source)
  vim.validate("ns_id", ns_id, "number")
  vim.validate("id", id, "number")
  if not namespaces[ns_id] then
    return false
  end
  namespaces[ns_id][id] = source
  return true
end

--- @param ns_id integer
--- @param id integer?
--- @return any
function M.get(ns_id, id)
  vim.validate("ns_id", ns_id, "number")
  vim.validate("id", id, "number", true)
  local result = vim.tbl_deep_extend("force", id and namespaces[ns_id][id] or namespaces[ns_id], {})
  result.next_id = nil
  return result
end

--- @param ns_id integer
--- @param id integer?
function M.del(ns_id, id)
  vim.validate("ns_id", ns_id, "number")
  vim.validate("id", id, "number", true)
  local namespace = namespaces[ns_id]
  if not namespace then
    return
  end
  if not id then
    namespaces[ns_id] = nil
  else
    namespace[id] = nil
  end
end

--- @param ns_id integer
--- @param id integer?
--- @return boolean
function M.has(ns_id, id)
  vim.validate("ns_id", ns_id, "number")
  vim.validate("id", id, "number", true)
  local namespace = namespaces[ns_id]
  if not namespace then
    return false
  end
  return id and namespace[id] ~= nil or true
end

return M
