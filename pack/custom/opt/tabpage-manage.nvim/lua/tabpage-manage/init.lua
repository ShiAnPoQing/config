local M = {}

--- @class TabpageManageOptions

--- @param options? TabpageManageOptions
function M.setup(options) end

function M.tabpage_manage()
  local tabpages = vim.api.nvim_list_tabpages()
  local current_tabpage = vim.api.nvim_get_current_tabpage()

  vim.print(tabpages, current_tabpage)
end

return M
