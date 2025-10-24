local M = {}

--- @class NeoTerminal.TerminalOptions
--- @field direction "float" | "top" | "left" | "right" | "bottom"

--- @param opts NeoTerminal.TerminalOptions
function M.terminal(opts)
  local Window = require("neo-terminal.window")
  if not Window:is_valid() then
    Window:f()
  else
    Window:close()
  end
end

return M
