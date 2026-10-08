--- @class my
--- @field env my.env
--- @field command my.command
--- @field keymap my.keymap
--- @field window my.window
--- @field scroll my.scroll
--- @field multicursor my.multicursor
--- @field insert my.insert
--- @field operator my.operator
--- @field motion my.motion
--- @field cursor my.cursor
--- @field util my.util
--- @field option my.option
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
  operator = true,
  option = true,
  util = true,
  env = true,
  scroll = true,
}

setmetatable(my, {
  __index = function(t, key)
    if type(key) == "number" then
      return my.env.get(key)
    end
    if my._submodules[key] then
      t[key] = require("my." .. key)
      return t[key]
    end
    local env = my.env.get(0)
    if env then
      return env[key]
    end
  end,
})

do
  --- @param scope string
  --- @param handle? false|integer
  --- @param opts { setvar: fun(scope: string, handle:any, k: any, v: any): any; getvar: fun(scope: string, handle:any, k: any): any }
  --- @return vim.var_accessor
  local function make_dict_accessor(scope, handle, opts)
    vim.validate("scope", scope, "string")
    local mt = {}
    --- @param k string
    --- @param v any
    function mt.__newindex(_, k, v)
      return opts.setvar(scope, handle, k, v)
    end

    --- @param k string|integer
    function mt.__index(_, k)
      if handle == nil and type(k) == "number" then
        return make_dict_accessor(scope, k, opts)
      end
      return opts.getvar(scope, handle, k)
    end
    return setmetatable({}, mt)
  end

  local opts = {
    setvar = function(scope, handle, k, v)
      if handle then
        local vars = vim[scope][handle].my or {}
        vars[k] = v
        vim[scope][handle].my = vars
      else
        local vars = vim[scope].my or {}
        vars[k] = v
        vim[scope].my = vars
      end
      return true
    end,
    getvar = function(scope, handle, k)
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
    end,
  }

  my.g = make_dict_accessor("g", false, opts)
  my.b = make_dict_accessor("b", nil, opts)
  my.w = make_dict_accessor("w", nil, opts)
  my.t = make_dict_accessor("t", nil, opts)

  local _opts = {
    setvar = function(scope, handle, k, v)
      return my.option.set(scope, handle, k, v)
    end,
    getvar = function(scope, handle, k)
      return my.option.get(scope, handle, k)
    end,
  }
  my.go = make_dict_accessor("g", false, _opts)
  my.bo = make_dict_accessor("b", nil, _opts)
end
