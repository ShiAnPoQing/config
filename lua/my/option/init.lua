--- @class my.option
local M = vim._defer_require("my.option", {})

local option_specs = {
  env = {
    type = "string",
    -- list = { "pro", "promax" },
    scope = { "g" },
    default = "pro",
    setter = function(_, _, _, v)
      my.env.set(vim.api.nvim_create_namespace(v))
    end,
  },
}

--- @param k any
--- @return boolean
local function check_option_name(k)
  if not option_specs[k] then
    vim.notify(string.format("my.option: Unknown option: '%s'", k), vim.log.levels.ERROR)
    return false
  end
  return true
end

--- @param scope string,
--- @param k any
--- @param v any
--- @return boolean
local function check_option_value(scope, k, v)
  if not vim.list_contains(option_specs[k].scope, scope) then
    return false
  end
  if not check_option_name(k) then
    return false
  end
  if type(v) ~= option_specs[k].type then
    vim.notify(
      string.format("my.option: Invalid '%s': expected a valid type, got %s", k, type(v)),
      vim.log.levels.ERROR
    )
    return false
  end
  if not option_specs[k].list then
    return true
  end
  if not vim.list_contains(option_specs[k].list, v) then
    vim.notify(
      string.format("my.option: Invalid '%s': expected one of %s, got %s", k, vim.inspect(option_specs[k].list), v),
      vim.log.levels.ERROR
    )
    return false
  end

  return true
end

--- @param scope string
--- @param handle false|integer
--- @param k any
--- @param v any
function M.set(scope, handle, k, v)
  if not check_option_value(scope, k, v) then
    return
  end
  if handle then
    local vars = my[scope][handle]._options or {}
    if vars[k] == v then
      return
    end
    vars[k] = v
    my[scope][handle]._options = vars
  else
    local vars = my[scope]._options or {}
    if vars[k] == v then
      return
    end
    vars[k] = v
    my[scope]._options = vars
  end
  if option_specs[k].setter then
    option_specs[k].setter(scope, handle, k, v)
  end
  return true
end

--- @param scope string
--- @param handle false|integer
--- @param k any
--- @return any
function M.get(scope, handle, k)
  if not check_option_name(k) then
    return nil
  end
  if handle then
    if my[scope][handle]._options == nil then
      return nil
    end
    return my[scope][handle]._options[k]
  else
    if my[scope]._options == nil then
      return nil
    end
    return my[scope]._options[k]
  end
end

return M
