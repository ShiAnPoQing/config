local M = {}

M.config = {}

function M.extend(opt)
  M.config = vim.tbl_deep_extend("force", M.config, opt or {})
end

return M
