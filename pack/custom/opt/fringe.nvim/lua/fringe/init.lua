local M = {}

--- @param opts? Fringe.Opts
function M.setup(opts)
  opts = opts or {}
  vim.validate("opts", opts, "table")
end

local COMPONENTS = { Text = true }
local create_template
local create_component

local function create_component_use(name, children)
  return function() end
end

function create_component(opts)
  local component
  local parent = opts.parent or {}
  local state = {}
  local template = {}
  local children = {}
  component = setmetatable({
    useTemplate = function(templates)
      for name, fc in ipairs(templates) do
        template[name] = setmetatable({}, {
          __call = function(_, ...)
            fc(create_template({ slot = select(1, ...), parent = component }))
          end,
          __index = function(_, k)
            return {}
          end,
        })
      end
    end,
    useState = function(states)
      for name, value in ipairs(states) do
        state[name] = value
      end
    end,
  }, {
    __index = function(t, k)
      if state[k] ~= nil then
        return state[k]
      end
      if template[k] ~= nil then
        return template[k]
      end
      if rawget(t, k) ~= nil then
        return rawget(t, k)
      end
      if COMPONENTS[k] ~= nil then
        return create_component_use(k, children)
      end
      return parent[k]
    end,
    __newindex = function(t, k, v)
      if template[k] ~= nil then
        vim.schedule(function()
          vim.api.nvim_echo({ { "Fringe.nvim: can't not change defined template" .. "'k'", "ErrorMsg" } }, true)
        end)
        return
      end
      if state[k] ~= nil then
        state[k] = v
        return
      end
      rawset(t, k, v)
    end,
  })
  return component
end

function create_template(opts)
  local slot_fc = opts.slot
  local component = create_component(opts)
  component.useTemplate({ Slot = slot_fc })
  return component
end

--- @param fc Fringe.ComponentFC<Fringe.TablineComponent>
function M.Tabline(fc)
  local component = create_component()
  fc(component)
end

--- @param fc Fringe.ComponentFC<Fringe.StatuslineComponent>
function M.Statusline(fc)
  local component = create_component()
  fc(component)
end

return M
