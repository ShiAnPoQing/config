local M = {}

local default_buf_option = {
  buftype = "acwrite",
  filetype = "buffer-manage",
}

local function set_buf_options(option)
  option = vim.tbl_deep_extend("force", default_buf_option, option or {})
  for key, value in pairs(option) do
    pcall(vim.api.nvim_set_option_value, key, value, {
      buf = M.buf,
    })
  end
end

local function is_buf_valid(buf)
  return vim.api.nvim_get_option_value("buflisted", {
    buf = buf,
  }) and vim.api.nvim_buf_is_valid(buf)
end

local function get_bufs(current_buf)
  local bufs = vim.api.nvim_list_bufs()
  local lines = {}
  local cursor_line
  local map = {}

  for _, buf in ipairs(bufs) do
    if is_buf_valid(buf) then
      if buf == current_buf then
        cursor_line = #lines + 1
      end
      local bufname = vim.api.nvim_buf_get_name(buf)
      map[bufname] = buf
      table.insert(lines, bufname)
    end
  end

  return {
    lines = lines,
    map = map,
    cursor_line = cursor_line,
  }
end

--- @param opts? table<string, any>
function M:create(opts)
  if not self.buf then
    self.buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_name(self.buf, "Buffer Manage")
    set_buf_options(opts)
  end
end

function M:update(win, current_buf)
  if not is_buf_valid(current_buf) or not vim.api.nvim_win_is_valid(win) or not vim.api.nvim_buf_is_valid(self.buf) then
    return
  end

  self.bufs = get_bufs(current_buf)
  vim.api.nvim_buf_set_lines(self.buf, 0, -1, false, self.bufs.lines)
  vim.api.nvim_set_option_value("modified", false, {
    buf = self.buf,
  })

  if not self.bufs.cursor_line then
    return
  end

  if not self.sign_id then
    self.sign_id = vim.api.nvim_create_namespace("buffer-manage-current-buffer")
  end

  vim.api.nvim_win_set_cursor(win, { self.bufs.cursor_line, 0 })
  vim.api.nvim_buf_set_extmark(self.buf, self.sign_id, self.bufs.cursor_line - 1, 0, {
    sign_text = "",
    sign_hl_group = "Type",
    invalidate = true,
  })
end

return M
