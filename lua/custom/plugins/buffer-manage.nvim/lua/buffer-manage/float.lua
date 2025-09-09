local M = {}

local default_win_option = {
  number = true,
  relativenumber = true,
  cursorline = true,
  signcolumn = "yes",
}

--- @type vim.api.keyset.win_config
local default_config = {
  relative = "editor",
  height = 10,
  col = 0,
  style = "minimal",
  border = "single",
  title = "Buffer Manage",
}

local function set_win_options(option)
  for key, value in pairs(option) do
    vim.api.nvim_set_option_value(key, value, {
      win = M.win,
    })
  end
end

local function get_config(config)
  config = vim.tbl_deep_extend("force", default_config, config or {})
  local max_width = vim.opt.columns:get()
  local max_height = vim.opt.lines:get() - vim.opt.cmdheight:get() - 1
  config.width = math.floor(max_width * 0.7)
  config.col = math.floor((max_width - config.width) / 2)
  -- config.row = vim.opt.lines:get() - vim.opt.cmdheight:get() - 1 - 10
  config.row = math.floor((max_height - config.height) / 2)
  return config
end

local function get_option(option)
  return vim.tbl_deep_extend("force", default_win_option, option or {})
end

--- @class BufferManageFloatOptions
--- @field config? vim.api.keyset.win_config
--- @field option? table<string, any>

--- @param buf integer
--- @param opts? BufferManageFloatOptions
function M:create(buf, opts)
  opts = opts or {}
  local config = get_config(opts.config)
  local option = get_option(opts.option)
  self.win = vim.api.nvim_open_win(buf, true, config)
  set_win_options(option)
end

--- @param opts? BufferManageFloatOptions
function M:update(opts)
  opts = opts or {}
  local config = get_config(opts.config)
  local option = get_option(opts.option)
  vim.api.nvim_win_set_config(self.win, config)
  set_win_options(option)
end

return M
