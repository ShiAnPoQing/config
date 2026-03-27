local M = {}

function M.get_style_path()
  local source = debug.getinfo(1, "S").source
  local path = source:sub(2)
  return vim.fn.fnamemodify(path, ":h:h") .. "/styles"
end

return M
