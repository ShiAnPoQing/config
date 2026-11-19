--- @diagnostic disable: invisible
--- @class my.ui.Window.Opts.Title
--- @field text? string
--- @field align? "center"|"left"|"right"

--- @class my.ui.Window.Opts
--- @field size? number|string|my.ui.Opts.Size
--- @field focusable? boolean
--- @field enter? boolean
--- @field border? any[]|""|"none"|"single"|"double"|"rounded"|"solid"|"shadow"|"bold"
--- @field zindex? integer
--- @field title? my.ui.Window.Opts.Title
--- @field buf_options? table<string, any>
--- @field win_options? table<string, any>
--- @field buf? integer

--- @class my.ui.Window.WinConfig
--- @field focusable boolean
--- @field style "minimal"
--- @field zindex integer
--- @field relative "cursor"|"editor"|"laststatus"|"mouse"|"tabline"
--- @field row integer
--- @field col integer
--- @field width integer
--- @field height integer
--- @field border? any[]|""|"none"|"single"|"double"|"rounded"|"solid"|"shadow"|"bold"
--- @field anchor? "NW"|"NE"|"SW"|"SE"
--- @field title? any
--- @field title_pos? "center"|"left"|"right"

--- @param win integer
--- @param options table<string, any>
local function set_win_options(win, options)
  for name, value in pairs(options) do
    vim.api.nvim_set_option_value(name, value, {
      scope = "local",
      win = win,
    })
  end
end

--- @param buf integer
--- @param options table<string, any>
local function set_buf_options(buf, options)
  for name, value in pairs(options) do
    vim.api.nvim_set_option_value(name, value, {
      scope = "local",
      buf = buf,
    })
  end
end

--- @class my.ui.Window: my.Instance<nil>
--- @field buf integer
--- @field win integer
--- @field win_options table<string, any>
--- @field buf_options table<string, any>
--- @field win_config my.ui.Window.WinConfig
--- @field mounted boolean
--- @field parent? my.ui.Box|my.ui.Container
--- @field size my.ui.Size
--- @field position my.ui.Position
--- @field pending my.ui.Pending
local Window = my.class("my.ui.Window")

--- @param opts my.ui.Window.Opts
function Window:init(opts)
  self.win_options = opts.win_options or {}
  self.buf_options = opts.buf_options or {}
  ---@diagnostic disable-next-line: missing-fields
  self.win_config = {
    focusable = opts.focusable,
    style = "minimal",
    zindex = opts.zindex,
    border = opts.border,
  }
  self.pending = { size = my.ui.util.normalize_size(opts.size) }
  if opts.buf then
    self.buf = opts.buf
  else
    self:_create_buf()
  end
end

function Window:mount()
  if self.mounted then
    return
  end
  self:_create_buf()
  set_buf_options(self.buf, self.buf_options)
  self:_open_window()
  self.mounted = true
end

function Window:unmount()
  self:_destory_buf()
  self:_close_window()
  self.mounted = false
end

function Window:hide() end

function Window:show() end

--- @param event string[]|string
--- @param handler fun(args: vim.api.keyset.create_autocmd.callback_args)
--- @param opts vim.api.keyset.create_autocmd
function Window:on(event, handler, opts)
  if not self.buf then
    return
  end
end

--- @param event string[]|string
function Window:off(event) end

function Window:_open_window()
  if self.win then
    return
  end

  self.win_config.width = self.size.width
  self.win_config.height = self.size.height
  self.win_config.relative = self.position.relative
  self.win_config.col = self.position.col
  self.win_config.row = self.position.row
  self.win_config.noautocmd = true
  ---@diagnostic disable-next-line: param-type-mismatch
  self.win = vim.api.nvim_open_win(self.buf, false, self.win_config)
  self.win_config.noautocmd = nil

  set_win_options(self.win, self.win_options)
end

function Window:_close_window()
  if not self.win then
    return
  end

  if vim.api.nvim_win_is_valid(self.win) then
    vim.api.nvim_win_close(self.win, true)
  end

  self.win = nil
end

function Window:_create_buf()
  if not self.buf then
    self.buf = vim.api.nvim_create_buf(false, true)
  end
end

function Window:_destory_buf()
  if not self.buf then
    return
  end
  if vim.api.nvim_buf_is_valid(self.buf) then
    vim.api.nvim_buf_delete(self.buf, { force = true })
  end
  self.buf = nil
end

--- @class my.ui.Class.Window: my.Class<my.ui.Class.Window>
--- @overload fun(opts: my.ui.Window.Opts): my.ui.Window

return Window --[[@as my.ui.Class.Window]]
