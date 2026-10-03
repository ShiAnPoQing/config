--- @class my
--- @field command my.command
--- @field keymap my.keymap
--- @field window my.window
--- @field multicursor my.multicursor
--- @field insert my.insert
--- @field operator my.operator
--- @field motion my.motion
--- @field cursor my.cursor
--- @field util my.util
--- @field g my.g
--- @field b my.b
--- @field w my.w
--- @field t my.t

--- @class my.g: { [string]: any }
--- @class my.b: vim.var_accessor
--- @class my.w: vim.var_accessor
--- @class my.t: vim.var_accessor

--- @type my
_G.my = _G.my or {}
my._submodules = {
  command = true,
  keymap = true,
  window = true,
  multicursor = true,
  cursor = true,
  insert = true,
  operator = true,
  motion = true,
  util = true,
}

setmetatable(my, {
  __index = function(t, key)
    if my._submodules[key] then
      t[key] = require("my." .. key)
      return t[key]
    end
  end,
})

do
  --- @param scope string
  --- @param handle? false|integer
  --- @return vim.var_accessor
  local function make_dict_accessor(scope, handle)
    vim.validate("scope", scope, "string")
    local mt = {}
    --- @param k string
    --- @param v any
    function mt.__newindex(_, k, v)
      if handle then
        local vars = vim[scope][handle].my or {}
        vars[k] = v
        vim[scope][handle].my = vars
      else
        local vars = vim[scope].my or {}
        vars[k] = v
        vim[scope].my = vars
      end
    end
    --- @param k string|integer
    function mt.__index(_, k)
      if handle == nil and type(k) == "number" then
        return make_dict_accessor(scope, k)
      end
      if handle then
        if vim[scope][handle].my == nil then
          return nil
        end
        return vim[scope][handle].my[k]
      else
        if vim[scope].my == nil then
          return nil
        end
        return vim[scope].my[k]
      end
    end
    return setmetatable({}, mt)
  end

  my.g = make_dict_accessor("g", false)
  my.b = make_dict_accessor("b")
  my.w = make_dict_accessor("w")
  my.t = make_dict_accessor("t")
end
