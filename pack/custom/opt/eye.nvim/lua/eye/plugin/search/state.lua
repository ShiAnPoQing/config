--- @class Eye.Plugin.Search.State
local M = {}

--- @class Eye.SearchState
--- @field children table<string, Eye.SearchState>
--- @field Eye Eye.Root

function M:init()
  --- @type Eye.SearchState
  ---@diagnostic disable-next-line: missing-fields
  self.state = {
    children = {},
  }
end

--- @param name string
--- @param Eye Eye.Root
--- @return Eye.SearchState
function M:register(name, Eye)
  local names = vim.split(name, "")
  --- @type Eye.SearchState|nil
  local state = self.state
  for _, n in ipairs(names) do
    if not state.children[n] then
      state.children[n] = {
        Eye = Eye,
        children = {},
      }
    end
    state = state.children[n]
  end

  return state
end

--- @return Eye.SearchState|nil
function M:query(names)
  names = vim.split(names, "")
  --- @type Eye.SearchState|nil
  local state = self.state
  for _, name in ipairs(names) do
    if state and state.children[name] then
      state = state.children[name]
    else
      state = nil
    end
  end

  return state
end

return M
