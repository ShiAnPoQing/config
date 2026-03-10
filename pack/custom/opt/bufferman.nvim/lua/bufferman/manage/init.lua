local M = {}
local UI = {}

function M:init(opt)
  if opt.win ~= nil then
    self.current_win = opt.win
    self.current_buf = vim.api.nvim_win_get_buf(opt.win)
  else
    local current_buf = vim.api.nvim_get_current_buf()
    if
      vim.api.nvim_buf_is_valid(current_buf)
      and vim.api.nvim_get_option_value("buflisted", {
        buf = current_buf,
      })
    then
      self.current_buf = vim.api.nvim_get_current_buf()
      self.current_win = vim.api.nvim_get_current_win()
    else
      return
    end
  end
  self.buffer_names = nil
  self:update()
end

local function get_buffers(current_buf)
  local buffer_names = {}
  local current_buf_index
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_get_option_value("buflisted", {
      buf = buf,
    }) then
      buffer_names[#buffer_names + 1] = vim.api.nvim_buf_get_name(buf)
      if buf == current_buf then
        current_buf_index = #buffer_names
      end
    end
  end
  return buffer_names, current_buf_index
end

function M:get_buffer_names()
  return self.buffer_names
end

function M:update()
  if not self.buffer_names then
    local buffer_names, current_buf_index = get_buffers(self.current_buf)
    self.buffer_names = buffer_names
    self.current_buf_index = current_buf_index
  else
    local old_buffer_names = self.buffer_names
    self.buffer_names = vim.api.nvim_buf_get_lines(UI.get_ui_info().buf, 0, -1, false)
    self.current_buf_index = 1
    local deletions = {}
    for _, bufname in ipairs(old_buffer_names) do
      if not vim.list_contains(self.buffer_names, bufname) then
        deletions[#deletions + 1] = function()
          local bufnr = vim.fn.bufnr(bufname)
          pcall(vim.api.nvim_buf_delete, bufnr, { force = true })
        end
      end
    end
    vim.schedule(function()
      for _, cb in ipairs(deletions) do
        cb()
      end
    end)
  end

  self.OnUpdate()
end

function M:switch()
  local cursor_row = vim.fn.line(".")
  local current_buf = vim.api.nvim_get_current_line()
  if not vim.list_contains(self.buffer_names, current_buf) then
    return
  end
  local bufnr = vim.fn.bufnr(current_buf)
  if not bufnr then
    return
  end

  vim.api.nvim_win_set_buf(self.current_win, bufnr)
  self.current_buf = bufnr
  self.current_buf_index = cursor_row

  self.OnSwitch()
end

function M:clean()
  self.current_buf = nil
  self.current_win = nil
end

function M:register(share)
  UI.get_ui_info = share.get_ui_info
  self.OnUpdate = share.OnUpdate
  self.OnSwitch = share.OnSwitch
end

return M
