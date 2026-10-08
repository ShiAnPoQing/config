--- @class my.env
local M = {}
local _envs = {}
local current_env_id

local envs = setmetatable({ _envs = _envs }, {
  __index = function(_, k)
    if not _envs[k] then
      return
    end
    return require(_envs[k])
  end,
})

--- @param env string
function M.register(env)
  vim.validate("env", env, "string")
  local ns = vim.api.nvim_create_namespace(env)
  _envs[ns] = env
  return ns
end

--- @param id integer
function M.get(id)
  id = id == 0 and current_env_id or id
  return envs[id]
end

--- @param id integer
function M.set(id)
  if id == current_env_id then
    return
  end
  if not envs[id] then
    return
  end
  current_env_id = id
end

function M.list()
  local list = {}
  for id, path in pairs(_envs) do
    table.insert(list, {
      id = id,
      module = path,
    })
  end
  return list
end

return M
