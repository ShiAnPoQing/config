--- @class my.keymap
--- @field key my.keymap.key
local M = vim._defer_require("my.keymap", {
  key = ..., --- @module 'my.keymap.key'
})

---@param modes string|string[] Mode "short-name" (see |nvim_set_keymap()|), or a list thereof.
---@param lhs string|string[]  Left-hand side |{lhs}| of the mapping, or a list thereof.
---@param rhs string|function  Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param opts? vim.keymap.set.Opts
function M.set(modes, lhs, rhs, opts)
  vim.validate("lhs", lhs, { "string", "table" })
  lhs = type(lhs) == "table" and lhs or { lhs } --[[@as table<string>]]
  for i, v in ipairs(lhs) do
    lhs[i] = M.key.translate(v)
  end
  vim.keymap.set(modes, lhs, rhs, opts)
end

---@param modes string|string[]
---@param lhs string|string[]
---@param opts? vim.keymap.del.Opts
function M.del(modes, lhs, opts)
  vim.validate("lhs", lhs, { "string", "table" })
  lhs = type(lhs) == "table" and lhs or { lhs } --[[@as table<string>]]
  for i, v in ipairs(lhs) do
    lhs[i] = M.key.translate(v)
  end
  vim.keymap.del(modes, lhs, opts)
end

return M
