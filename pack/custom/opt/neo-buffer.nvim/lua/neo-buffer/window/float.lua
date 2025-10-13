local Window = require("neo-buffer.window.window")

local M = {}

local function get_config(config)
  local max_width = vim.opt.columns:get()
  ---@diagnostic disable-next-line: undefined-field
  local max_height = vim.opt.lines:get() - vim.opt.cmdheight:get() - 1
  config.width = math.floor(max_width * 0.7)
  config.col = math.floor((max_width - config.width) / 2)
  -- config.row = vim.opt.lines:get() - vim.opt.cmdheight:get() - 1 - 10
  config.row = math.floor((max_height - config.height) / 2)
  return config
end

local function get_option(option)
  return option
end

local function set_win_options(option)
  for key, value in pairs(option) do
    vim.api.nvim_set_option_value(key, value, {
      win = M.win,
    })
  end
end

function M:create(buf)
  local config = get_config(Window.default_config)
  local option = get_option(Window.default_win_option)
  self.win = vim.api.nvim_open_win(buf, true, config)
  set_win_options(option)
end

function M:update()
  local config = get_config(Window.default_config)
  local option = get_option(Window.default_win_option)
  vim.api.nvim_win_set_config(self.win, config)
  set_win_options(option)
end

return M
