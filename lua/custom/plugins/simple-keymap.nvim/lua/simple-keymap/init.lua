local M = {}
local Keymap = require("simple-keymap.keymap")

--- @class SimpleKeymapOpts
--- @field add? table
--- @field del? table

--- @param opts? SimpleKeymapOpts
function M.setup(opts)
  Keymap.load(opts)
end

return M
