--- @class my.multicursor
--- @field mouse my.multicursor.mouse
--- @field register my.multicursor.register
--- @field ns integer
--- @field cursor my.multicursor.cursor
--- @field visual my.multicursor.visual
local M = {
  _submodules = {
    mouse = true,
    register = true,
    cursor = true,
    visual = true,
  },
}

setmetatable(M, {
  --- @param t table<any,any>
  __index = function(t, key)
    if M._submodules[key] then
      t[key] = require("my.multicursor." .. key)
      return t[key]
    elseif key == "ns" then
      return vim.api.nvim_create_namespace("nvim.multicursor")
    end
  end,
})

--- @return boolean
function M.active()
  return #vim.api.nvim_buf_get_extmarks(0, M.ns, 0, -1, { limit = 1 }) > 0
end

--- @param buf number
--- @param pos [integer, integer]
--- @return integer
function M.add(buf, pos)
  return vim.api.nvim_mcursor(buf, pos)
end

--- @param buf integer
--- @param line_start integer?
--- @param line_end integer?
function M.clear(buf, line_start, line_end)
  if not line_start then
    line_start = 0
  end
  if not line_end then
    line_end = -1
  end
  vim.api.nvim_buf_clear_namespace(buf, M.ns, line_start, line_end)
end

--- @param buf integer
--- @param id integer
--- @return boolean
function M.del(buf, id)
  return vim.api.nvim_buf_del_extmark(buf, M.ns, id)
end

--- @param buf integer
--- @return vim.api.keyset.get_extmark_item[]
function M._all(buf)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local items = M.get(buf, 0, -1)
  table.insert(items, 1, { 0, cursor[1] - 1, cursor[2] })
  return items
end

--- @param buf integer
--- @param start any
--- @param end_ any
--- @param opts? vim.api.keyset.get_extmarks
--- @return vim.api.keyset.get_extmark_item[]
function M.get(buf, start, end_, opts)
  opts = opts or {}
  return vim.api.nvim_buf_get_extmarks(buf, M.ns, start, end_, opts)
end

local snapshots = {}

--- @param buf integer
function M.snapshot(buf)
  if buf == 0 then
    buf = vim.api.nvim_get_current_buf()
  end
  snapshots[tostring(buf)] = M._all(buf)
end

--- @param buf integer
function M.get_snapshot(buf)
  if buf == 0 then
    buf = vim.api.nvim_get_current_buf()
  end
  return snapshots[tostring(buf)]
end

return M
