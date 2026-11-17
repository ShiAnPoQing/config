---@diagnostic disable: invisible
--- @class my.ui.Window.Size
--- @field width integer
--- @field height integer

--- @class my.ui.Window.Opts
--- @field size my.ui.Window.Size
--- @field focusable? boolean
--- @field border? any
--- @field zindex? integer
--- @field buf? integer
--- @field buf_options? table<string, any>
--- @field win_options? table<string, any>

--- @class my.ui.Window.WinConfig
--- @field focusable boolean
--- @field style "minimal"
--- @field zindex integer
--- @field relative "cursor"|"editor"|"laststatus"|"mouse"|"tabline"
--- @field row number
--- @field col number
--- @field width integer
--- @field height integer
--- @field border? any[]|""|"none"|"single"|"double"|"rounded"|"solid"|"shadow"|"bold"
--- @field anchor? "NW"|"NE"|"SW"|"SE"
--- @field title? any
--- @field title_pos? "center"|"left"|"right"

--- @class my.ui.Window: my.Instance<nil>
--- @field buf integer
--- @field win integer
--- @field win_options table<string, any>
--- @field buf_options table<string, any>
--- @field win_config my.ui.Window.WinConfig

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

--- @class my.ui.Class.Window: my.Class<my.ui.Class.Window>
--- @overload fun(opts: my.ui.Window.Opts): my.ui.Window|my.ui.Class.Window
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
  }
  if opts.buf then
    self.buf = opts.buf
  else
    self.buf = vim.api.nvim_create_buf(false, true)
  end
end

function Window:mount()
  if self.mounted then
    return
  end
  self.mounted = true
end

function Window:unmount() end

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
  if self.win or self.buf then
    return
  end

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

return Window
