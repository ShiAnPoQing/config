local M = {}

--- @type vim.api.keyset.win_config
local default_float_win_config = {}

--- @type vim.api.keyset.win_config
local default_split_win_config = {}

local default_win_option = {
  number = true,
  relativenumber = true,
  cursorline = true,
  signcolumn = "yes",
}

local function set_win_options(option)
  for key, value in pairs(option) do
    vim.api.nvim_set_option_value(key, value, {
      win = M.win,
    })
  end
end

function M:create(buf, opts)
  opts = opts or {}
  local config = {}
  local option = {}
  self.win = vim.api.nvim_open_win(buf, true, config)
  set_win_options(option)
end

function M:update(opts)
  opts = opts or {}
  local config = {}
  local option = {}
  vim.api.nvim_win_set_config(self.win, config)
  set_win_options(option)
end

return M
