local M = {}
local UI = {}

local function get_absolute_buffer_name(buffer_name)
  return vim.fn.fnamemodify(buffer_name, ":p")
end

local function get_relative_buffer_name(buffer_name)
  return vim.fn.fnamemodify(buffer_name, ":t")
end

local function is_buflisted(buf)
  return vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_get_option_value("buflisted", {
    buf = buf,
  })
end

local function create_buffer(buffer_name, buf)
  return {
    buffer_name = buffer_name,
    file_name = get_relative_buffer_name(buffer_name),
    buf = buf,
  }
end

local function get_neovim_buffers(init_buf)
  local buffer_map = {}
  local buffer_order = {}
  local current
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if is_buflisted(buf) then
      local buffer_name = vim.api.nvim_buf_get_name(buf)
      local buffer = create_buffer(buffer_name, buf)
      buffer_map[buffer_name] = buffer
      buffer_order[#buffer_order + 1] = buffer_name

      if buf == init_buf then
        current = buffer
      end
    end
  end

  return buffer_map, buffer_order, current
end

function M:init()
  local buf = vim.api.nvim_get_current_buf()
  if is_buflisted(buf) then
    self.win = vim.api.nvim_get_current_win()
    self.buf = buf
    local buffer_map, buffer_order, current = get_neovim_buffers(self.buf)
    self.buffer_map = buffer_map
    self.buffer_order = buffer_order
    self.current = current
  end
end

function M:update(flag)
  if flag == "diff" then
    self.buf = vim.api.nvim_win_get_buf(self.win)
    local older_buffer_map = self.buffer_map
    local new_buffer_map = {}
    local lines = UI.get_lines()

    local new_buffer_order = {}
    local add_buffer_names = {}
    local remove_buffer_map = vim.tbl_deep_extend("force", {}, older_buffer_map)
    for _, buffer_name in ipairs(lines) do
      local absolute_buffer_name = get_absolute_buffer_name(buffer_name)
      if absolute_buffer_name ~= buffer_name then
        buffer_name = get_absolute_buffer_name(vim.fn.getcwd() .. "/" .. buffer_name)
      end

      if older_buffer_map[buffer_name] then
        remove_buffer_map[buffer_name] = nil
        if not new_buffer_map[buffer_name] then
          new_buffer_map[buffer_name] = older_buffer_map[buffer_name]
          new_buffer_order[#new_buffer_order + 1] = buffer_name
        end
      else
        add_buffer_names[#add_buffer_names + 1] = buffer_name
        new_buffer_order[#new_buffer_order + 1] = buffer_name
      end
    end

    for _, remove_buffer in pairs(remove_buffer_map) do
      if remove_buffer.buffer_name == self.current.buffer_name then
        vim.api.nvim_buf_call(self.current.buf, function()
          vim.cmd("bd")
        end)
      else
        vim.api.nvim_buf_delete(remove_buffer.buf, { force = false })
      end
    end

    for _, add_buffer_name in ipairs(add_buffer_names) do
      local buf = vim.fn.bufadd(add_buffer_name)
      vim.api.nvim_set_option_value("buflisted", true, {
        buf = buf,
      })
      new_buffer_map[add_buffer_name] = create_buffer(add_buffer_name, buf)
    end

    self.buffer_map = new_buffer_map
    self.buffer_order = new_buffer_order
    self.current = self.buffer_map[vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(self.win))]
  end

  self.OnUpdate()
end

function M:switch()
  local current_buffer_name = vim.fn.fnamemodify(vim.api.nvim_get_current_line(), ":p")
  local current_buffer = self.buffer_map[current_buffer_name]
  if not current_buffer then
    return
  end
  vim.api.nvim_win_set_buf(self.win, current_buffer.buf)
  self.current = current_buffer
  self.OnSwitch()
end

function M:clean()
  self.win = nil
  self.current = nil
end

function M:register(share)
  UI.get_lines = share.get_lines
  self.OnUpdate = share.OnUpdate
  self.OnSwitch = share.OnSwitch
end

function M:get_buffer_data()
  local buffer_data = {}

  for _, buffer_name in ipairs(self.buffer_order) do
    local buffer = self.buffer_map[buffer_name]
    local file_type = vim.api.nvim_get_option_value("filetype", { buf = buffer.buf })
    buffer_data[#buffer_data + 1] = {
      line = vim.fn.fnamemodify(buffer_name, ":."),
      icon = {
        icon = require("nvim-web-devicons").get_icon(buffer.buffer_name, file_type, { default = true }),
        hl_group = "DevIcon" .. string.upper(string.sub(file_type, 1, 1)) .. string.sub(file_type, 2),
      },
    }
  end

  return buffer_data
end

function M:get_current()
  return self.current
end

function M:get_current_index()
  if not self.current then
    return
  end

  for i, buffer_name in ipairs(self.buffer_order) do
    if buffer_name == self.current.buffer_name then
      return i
    end
  end
end

return M
