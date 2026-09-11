local M = {}

--- @class _Eye.Highlight.Config

--- @type _Eye.Highlight.Config
local default_config = {}

--- @param ... _Eye.Highlight.Config[]
--- @return _Eye.Highlight.Config
function M.merge(...)
  return vim.tbl_deep_extend("force", default_config, ...)
end

return M
