-- [lhs] = {rhs, mode, key=vlaue},
-- [lhs] = {rhs, {mode1, mode2}, key=value},
-- [lhs] = {rhs, {mode1, mode2, key=value}, key=value},
-- [lhs] = {rhs, {mode1, {mode2, key=value} key=value}, key=value}
-- [lhs] = {rhs, {mode1, {mode2, mode3, key=value} key=value}, key=value}
-- ["lhs"] = {
--   {rhs, mode, key=value},
--   {rhs, {mode1, mode2}, key=value},
--   key=value
-- }

local M = {}

local OptsMap = {
  noremap = true,
  nowait = true,
  silent = true,
  script = true,
  expr = true,
  unique = true,
  callback = true,
  desc = true,
  replace_keycodes = true,
}

local cache = {}

--- @class ParseKeymapOpts
--- @field add? table<string, table>|fun(loader): ...: table<string, table>
--- @field del? table<string, table>|fun(loader): ...: table<string, table>

--- @param mode string|string[]
--- @param lhs string
--- @param rhs string|function
--- @param opts? vim.keymap.set.Opts
local function set_keymap(mode, lhs, rhs, opts)
  local ok = pcall(vim.keymap.set, mode, lhs, rhs, opts)
  if not ok then
  end
end

--- @param source table<string, any>
local function filter_keymap_opts(source)
  local opts = {}
  for index, value in ipairs(source) do
    if OptsMap[index] then
      opts[index] = value
    end
  end
  return opts
end

local function _loader(...)
  local params = { ... }
  local base = cache.base
  if base == nil then
    base = vim.fn.stdpath("config") .. "/lua/"
    cache.base = base
  end

  local sources = {}

  for _, path in ipairs(params) do
    if vim.endswith(path, "/") then
      path = base .. path .. "*.lua"
    else
      path = base .. path .. ".lua"
    end

    local files = vim.fn.glob(path, true, true)
    for _, file in ipairs(files) do
      local module_path = file:gsub(base, ""):gsub("%.lua$", "")
      local success, v = pcall(require, module_path)
      if success and type(v) == "table" then
        sources = vim.tbl_extend("force", sources, v)
      end
    end
  end
  return sources
end

local function get_keymap_source(source)
  source = type(source) == "function" and source(_loader) or source
  return type(source) == "table" and source or {}
end

--- @param opts ParseKeymapOpts
local function loader(opts)
  local add = opts.add or {}
  local del = opts.del or {}

  local add_sources = get_keymap_source(add)
  local del_sources = get_keymap_source(del)

  M.add(add_sources)
  M.del(del_sources)
end

function M.add(source)
  vim.print(source)
end

function M.del(source) end

--- @param opts? ParseKeymapOpts
function M.setup(opts)
  opts = opts or {}
  loader(opts)
  return M
end

M.setup({
  add = function(l)
    return {}
  end,
})

return M
