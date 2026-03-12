local M = {}

local default_config = {
  relative = "editor",
  height = 10,
  col = 0,
  style = "minimal",
  border = "single",
  title = "BufferMan",
  title_pos = "center",
}

local function get_config(config)
  config = vim.tbl_deep_extend("force", default_config, config or {})
  local max_width = vim.opt.columns:get()
  local max_height = vim.opt.lines:get() - vim.opt.cmdheight:get() - 1
  config.width = math.floor(max_width * 0.7)
  config.col = math.floor((max_width - config.width) / 2)
  config.row = math.floor((max_height - config.height) / 2)
  return config
end

local function set_win_option(win)
  local win_option = {
    winfixbuf = true,
  }
  for key, value in pairs(win_option) do
    vim.api.nvim_set_option_value(key, value, {
      win = win,
    })
  end
end

function M:create(buf)
  local win_config = get_config({})
  self.win = vim.api.nvim_open_win(buf, true, win_config)
  set_win_option(self.win)
end

function M:update()
  local cursor_pos = self.Shared.get_cursor_pos()
  if cursor_pos and (type(cursor_pos[1]) == "number") then
    vim.api.nvim_win_set_cursor(self.win, cursor_pos)
  end
end

function M:destory()
  pcall(vim.api.nvim_win_close, self.win, true)
  self.win = nil
end

function M:resize()
  local config = get_config({})
  vim.api.nvim_win_set_config(self.win, config)
end

return M
