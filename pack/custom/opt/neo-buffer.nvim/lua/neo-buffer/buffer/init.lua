local M = {}

local function is_buf_listed(buf)
  return vim.api.nvim_get_option_value("buflisted", {
    buf = buf,
  })
end

local function is_buf_valid(buf)
  return vim.api.nvim_buf_is_valid(buf)
end

local default_buf_option = {
  buftype = "acwrite",
  filetype = "buffer-manage",
}

local function set_buf_options(options)
  for key, value in pairs(options) do
    pcall(vim.api.nvim_set_option_value, key, value, {
      buf = M.buf,
    })
  end
end

function M:create(opts)
  opts = vim.tbl_deep_extend("force", default_buf_option, opts or {})
  self.buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_name(self.buf, "Buffer Manage")
  set_buf_options(opts)
end

function M:update(win, current_buf)
  if not is_buf_valid(current_buf) or not vim.api.nvim_win_is_valid(win) or not vim.api.nvim_buf_is_valid(self.buf) then
    return
  end

  local buffers = vim.api.nvim_list_bufs()
  self.buffer_map = {}
  local lines = {}
  local cursor_line

  for _, buf in ipairs(buffers) do
    if is_buf_listed(buf) and is_buf_valid(buf) then
      if buf == current_buf then
        cursor_line = #lines + 1
      end
      local bufname = vim.api.nvim_buf_get_name(buf)
      self.buffer_map[bufname] = buf
      table.insert(lines, bufname)
    end
  end
  vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, lines)
  vim.api.nvim_set_option_value("modified", false, {
    buf = self.buf,
  })

  if cursor_line then
    vim.api.nvim_win_set_cursor(win, { cursor_line, 0 })
    self:set_mark(cursor_line)
  end
end

function M:set_mark(cursor_line)
  if not self.sign_id then
    self.sign_id = vim.api.nvim_create_namespace("neo-buffer-current-buffer")
  else
    vim.api.nvim_buf_clear_namespace(self.buf, self.sign_id, 0, -1)
  end
  vim.api.nvim_buf_set_extmark(self.buf, self.sign_id, cursor_line - 1, 0, {
    sign_text = "",
    sign_hl_group = "Type",
    invalidate = true,
  })
end

return M
