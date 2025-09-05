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

--- @class BufferManageFloatOptions
--- @field config? table<string, any>
--- @field option? vim.api.keyset.win_config

--- @param buf integer
--- @param opts? BufferManageFloatOptions
function M:create(buf, opts)
  opts = opts or {}
  local config = vim.tbl_deep_extend("force", default_config, opts.config or {})
  local option = vim.tbl_deep_extend("force", default_win_option, opts.option or {})
  config.width = vim.opt.columns:get()
  config.row = vim.opt.lines:get() - vim.opt.cmdheight:get() - 1 - 10

  self.win = vim.api.nvim_open_win(buf, true, config)
  set_win_options(option)
end

return M
