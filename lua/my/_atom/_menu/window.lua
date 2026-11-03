--- @class my._atom._menu.window
--- @field private win integer
--- @field private config my._atom._menu.window.Opts
local Win = {}
Win.__index = Win

--- @class my._atom._menu.window.Opts
--- @field border? any[]|""|"none"|"single"|"double"|"rounded"|"solid"|"shadow"|"bold"
--- @field height? integer
--- @field option? table<string, any>

--- @param opts my._atom._menu.window.Opts?
function Win:new(opts)
  vim.validate("opts", opts, "table", true)
  opts = opts or {}
  vim.validate("opts.option", opts.option, "table", true)
  opts.option = opts.option or {}
  local hl1 = vim.api.nvim_get_hl(0, { name = "Title", link = false })
  local hl2 = vim.api.nvim_get_hl(0, { name = "MsgSeparator", link = false })
  vim.api.nvim_set_hl(0, "MyAtomMenuWinbar", { overline = true, fg = hl1.fg, bg = hl2.bg })
  local win = setmetatable({}, {
    __newindex = function(t, k, v)
      if k == "win" then
        return
      end
      rawset(t, k, v)
    end,
    __index = self,
  })
  win.config = opts
  return win
end

function Win:get()
  return self.win
end

--- @param buf integer
--- @param opts? my._atom._menu.window.Opts
--- @return integer
function Win:open(buf, opts)
  vim.validate("buf", buf, "number")
  vim.validate("opts", opts, "table", true)
  local config = vim.tbl_deep_extend("force", self.config, opts or {})
  self.win = vim.api.nvim_open_win(buf, true, {
    relative = "laststatus",
    anchor = "SE",
    height = config.height or 1,
    width = 1000,
    row = 0,
    col = 0,
    style = "minimal",
    border = "none",
  })
  local options = config.option
  options["winhighlight"] = options["winhighlight"] or "Winbar:MyAtomMenuWinbar,Normal:Normal"
  for name, value in pairs(options or {}) do
    self:set_option(name, value)
  end
  return self.win
end

--- @param name string
--- @param value any
function Win:set_option(name, value)
  vim.api.nvim_set_option_value(name, value, { scope = "local", win = self.win })
end

function Win:is_opened()
  return self.win and vim.api.nvim_win_is_valid(self.win)
end

function Win:close()
  if not Win:is_opened() then
    return
  end
  vim.api.nvim_win_close(self.win, false)
  self.win = nil
end

return Win
