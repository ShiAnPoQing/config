local M = {}

function M:set_mark(buf, line)
  if not self.sign_id then
    self.sign_id = vim.api.nvim_create_namespace("buffer-manage-current-buffer")
  else
    vim.api.nvim_buf_clear_namespace(buf, self.sign_id, 0, -1)
  end
  vim.api.nvim_buf_set_extmark(buf, self.sign_id, line, 0, {
    sign_text = "",
    sign_hl_group = "Type",
    invalidate = true,
  })
end

return M
