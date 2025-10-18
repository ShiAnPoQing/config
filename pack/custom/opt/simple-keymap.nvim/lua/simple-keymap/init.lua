local M = {}
local Keymap = require("simple-keymap.keymap")

--- @class SimpleKeymap.Key.Mode.Config: vim.keymap.set.Opts
--- @field [integer] string|SimpleKeymap.Key.Mode.Config

--- @alias SimpleKeymap.Key.Mode
--- |string
--- |SimpleKeymap.Key.Mode.Config

--- @class SimpleKeymap.OneModeKey: vim.keymap.set.Opts
--- @field [1] string|fun()
--- @field [2] SimpleKeymap.Key.Mode

--- @class SimpleKeymap.MultiModeKey: vim.keymap.set.Opts
--- @field [integer] SimpleKeymap.OneModeKey

--- @alias SimpleKeymap.Key
--- | SimpleKeymap.OneModeKey
--- | SimpleKeymap.MultiModeKey
--- @alias SimpleKeymap.Keys table<string, SimpleKeymap.Key>

--- @class SimpleKeymapOpts
--- @field add? SimpleKeymap.Keys
--- @field del? table

--- @param opts? SimpleKeymapOpts
function M.setup(opts)
  Keymap.load(opts)
end

M.add = Keymap.add
M.del = Keymap.del
M.get = Keymap.get
M.get_keymaps = Keymap.get_keymaps

return M
