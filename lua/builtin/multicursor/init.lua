local M = {}

--- @param buf? integer
function M.buf_get_multicursor(buf)
  buf = buf or 0
  vim.validate("buf", buf, "number")
  return vim.api.nvim_buf_get_extmarks(buf, vim.api.nvim_create_namespace("nvim.multicursor"), 0, -1)
end

return M
