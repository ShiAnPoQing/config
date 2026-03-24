local M = {}

function M.update()
  local source = debug.getinfo(1, "S").source
  local path = source:sub(2)
  local doc_path = vim.fn.fnamemodify(path, ":h:h:h") .. "/doc"
  vim.cmd("helptags " .. doc_path)
end

return M
