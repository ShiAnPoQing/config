local M = {
  autocmds = {},
}

function M:create(opt)
  self.buf = vim.api.nvim_create_buf(false, true)
  local buf_option = {
    buftype = "acwrite",
    filetype = "bufferman",
  }
  vim.api.nvim_buf_set_name(self.buf, "Bufferman")
  for key, value in pairs(buf_option) do
    pcall(vim.api.nvim_set_option_value, key, value, {
      buf = self.buf,
    })
  end
  self:create_autocmd()

  vim.keymap.set("n", "<cr>", function()
    self.Shared.Buffer.events.OnEnter()
  end, { buffer = self.buf })
end

function M:destory()
  self:delete_autocmd()
  pcall(vim.api.nvim_buf_delete, self.buf, { force = true })
  self.buf = nil
  self.autocmds = {}
end

function M:update(opt)
  vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, self.Shared.Buffer.get_lines())
  local line = self.Shared.get_cursor_pos()[1]
  local ns_id = vim.api.nvim_create_namespace("buffer-manage")
  vim.api.nvim_buf_set_extmark(self.buf, ns_id, line - 1, 0, {
    end_row = line,
    hl_group = "Visual",
    hl_eol = true,
  })
  -- file_icon = require("nvim-web-devicons").get_icon(filename, file_type, { default = true })
  vim.api.nvim_buf_set_extmark(self.buf, ns_id, line - 1, 0, {
    sign_text = "",
    sign_hl_group = "Type",
    invalidate = true,
  })
end

function M:create_autocmd()
  local BufWriteCmd = vim.api.nvim_create_autocmd("BufWriteCmd", {
    callback = function()
      return self.Shared.Buffer.events.BufWriteCmd()
    end,
    buffer = self.buf,
  })
  local WinClosed = vim.api.nvim_create_autocmd("WinClosed", {
    callback = function()
      return self.Shared.Buffer.events.WinClosed()
    end,
    buffer = self.buf,
  })
  local VimResized = vim.api.nvim_create_autocmd("VimResized", {
    callback = function()
      return self.Shared.Buffer.events.VimResized()
    end,
  })
  local BufWinEnter = vim.api.nvim_create_autocmd("BufWinEnter", {
    callback = function(ev)
      return self.Shared.Buffer.events.BufWinEnter(ev)
    end,
  })
  local WinEnter = vim.api.nvim_create_autocmd("WinEnter", {
    callback = function(ev)
      return self.Shared.Buffer.events.WinEnter(ev)
    end,
  })
  table.insert(self.autocmds, BufWriteCmd)
  table.insert(self.autocmds, WinClosed)
  table.insert(self.autocmds, VimResized)
  table.insert(self.autocmds, BufWinEnter)
  table.insert(self.autocmds, WinEnter)
end

function M:delete_autocmd()
  for _, value in ipairs(self.autocmds) do
    pcall(vim.api.nvim_del_autocmd, value)
  end
end

return M
