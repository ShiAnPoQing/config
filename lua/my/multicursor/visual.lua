--- @class my.multicursor.visual
--- @field ns integer
local M = {}
setmetatable(M, {
  __index = function(t, key)
    if key == "ns" then
      return vim.api.nvim_create_namespace("nvim.multicursor.visual")
    end
  end,
})

--- @param buf integer
--- @param start any
--- @param end_ any
--- @param opts? vim.api.keyset.get_extmarks
--- @return vim.api.keyset.get_extmark_item[]
function M.get(buf, start, end_, opts)
  opts = opts or {}
  return vim.api.nvim_buf_get_extmarks(buf, M.ns, start, end_, opts)
end

--- @return boolean
function M.active()
  return #vim.api.nvim_buf_get_extmarks(0, M.ns, 0, -1, { limit = 1 }) > 0
end

return M
