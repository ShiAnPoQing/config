local M = {}

function M.get_buffer_names()
  local buffer_names = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_get_option_value("buflisted", {
      buf = buf,
    }) then
      buffer_names[#buffer_names + 1] = vim.api.nvim_buf_get_name(buf)
    end
  end

  return buffer_names
end

function M.update()
  vim.api.nvim_buf_set_lines(M.buf, 0, -1, false, M.get_buffer_names())
end

function M.create()
  M.buf = vim.api.nvim_create_buf(false, true)
  local buf_option = {
    buftype = "acwrite",
    filetype = "buffer-manage",
  }
  vim.api.nvim_buf_set_name(M.buf, "Buffer Manage")
  for key, value in pairs(buf_option) do
    pcall(vim.api.nvim_set_option_value, key, value, {
      buf = M.buf,
    })
  end
end

function M.delete()
  pcall(vim.api.nvim_buf_delete, M.buf, { force = true })
  M.buf = nil
end

return M
