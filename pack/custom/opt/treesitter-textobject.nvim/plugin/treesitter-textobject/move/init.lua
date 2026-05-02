local M = {}

--- @param config TreesitterTextobject.Spec
function M.move(config)
  local bufnr = vim.api.nvim_get_current_buf()
  local tree = vim.treesitter.get_parser(bufnr, config.language):parse()[1]
  local query = vim.treesitter.query.get(config.language, config.scm)
  if query == nil then
    return
  end
end

return M
