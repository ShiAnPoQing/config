--- @class my.keymap2.set.Opts: vim.keymap.set.Opts
--- @field ft? string|string[]
--- @field exclude_ft? string|string[]
--- @field event? string|string[]
--- @field depend? string|string[]

--- @class my.keymap2.del.Opts: vim.keymap.del.Opts

--- @class my.keymap2.set.Modes: my.keymap2.set.Opts
--- @field [integer] my.keymap2.set.Mode

--- @alias my.keymap2.set.Rhs string|fun()

--- @alias my.keymap2.set.Mode string|my.keymap2.set.Modes

--- @class my.keymap2.set.Spec: my.keymap2.set.Opts
--- @field [1] my.keymap2.set.Rhs
--- @field [2] my.keymap2.set.Mode

--- @class my.keymap2.set.Specs: my.keymap2.set.Opts
--- @field [integer] my.keymap2.set.Spec

--- @alias my.keymap2.set._Spec my.keymap2.set.Spec|my.keymap2.set.Specs

--- @class my.keymap2.del.Specs: vim.keymap.del.Opts
--- @field [integer] my.keymap2.del._Spec

--- @alias my.keymap2.del._Spec string|my.keymap2.del.Specs

--- @class my.keymap2
--- @field _core any
local M = my.module.defer_require("my.keymap2", { _core = true })

--- @param source table<string, my.keymap2.set._Spec>
function M.set(source, set)
  return M._core.set(source, set)
end

--- @param source table<string, my.keymap2.del._Spec>
function M.del(source)
  return M._core.del(source)
end

--- @param lhs? string
function M.get(lhs)
  return M._core.get(lhs)
end

return M
