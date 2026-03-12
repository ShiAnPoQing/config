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
  self:create_keymap()
end

function M:update(opt)
  local lines = {}
  local icons = {}
  for _, data in ipairs(self.Shared.Buffer.get_files()) do
    table.insert(lines, data.line)
    table.insert(icons, data.icon)
  end

  vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, lines)

  local ns_id = vim.api.nvim_create_namespace("buffer-manage")
  for i, icon in pairs(icons) do
    vim.api.nvim_buf_set_extmark(self.buf, ns_id, i - 1, 0, {
      sign_text = icon.icon,
      sign_hl_group = icon.hl_group,
      invalidate = true,
    })
  end

  local cursor_pos = self.Shared.get_cursor_pos()
  if not cursor_pos then
    return
  end
  local line = cursor_pos[1]
  vim.api.nvim_buf_set_extmark(self.buf, ns_id, line - 1, 0, {
    end_row = line,
    hl_group = "CursorLine",
    hl_eol = true,
  })
end

function M:destory()
  self:delete_autocmd()
  pcall(vim.api.nvim_buf_delete, self.buf, { force = true })
  self.buf = nil
  self.autocmds = {}
end

function M:create_keymap()
  vim.keymap.set("n", "<cr>", function()
    self.Shared.Buffer.events.OnEnter()
  end, { buffer = self.buf })
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
  local DirChanged = vim.api.nvim_create_autocmd("DirChanged", {
    callback = function(ev)
      if ev.match == "global" then
        return self.Shared.Buffer.events.DirChanged(ev)
      end
    end,
  })
  table.insert(self.autocmds, BufWriteCmd)
  table.insert(self.autocmds, WinClosed)
  table.insert(self.autocmds, VimResized)
  table.insert(self.autocmds, BufWinEnter)
  table.insert(self.autocmds, DirChanged)
end

function M:delete_autocmd()
  for _, value in ipairs(self.autocmds) do
    pcall(vim.api.nvim_del_autocmd, value)
  end
end

return M
