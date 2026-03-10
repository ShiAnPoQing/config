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

  vim.api.nvim_create_autocmd("BufWriteCmd", {
    callback = function()
      vim.print("hao")
      -- local lines = vim.api.nvim_buf_get_lines(Buffer.buf, 0, -1, false)
      -- for bufname, bufnr in pairs(Buffer.bufs.map) do
      --   if not vim.list_contains(lines, bufname) then
      --     if bufnr == vim.api.nvim_win_get_buf(current_win) then
      --       vim.api.nvim_buf_call(bufnr, function()
      --         vim.cmd("bd")
      --       end)
      --     else
      --       vim.api.nvim_set_option_value("buflisted", false, {
      --         buf = bufnr,
      --       })
      --       vim.api.nvim_buf_delete(bufnr, { force = true })
      --     end
      --   end
      -- end
      -- Buffer:update(Float.win, vim.api.nvim_win_get_buf(current_win))
    end,
    buffer = M.buf,
  })
end

function M.delete()
  pcall(vim.api.nvim_buf_delete, M.buf, { force = true })
  M.buf = nil
end

return M
