local M = {}
local Terminal = require("open-terminal.terminal")

--- @alias OpenTerminalDirection "below" | "above" | "left" | "right" | "float"

--- @class OpenTerminalOptions
--- @field direction? OpenTerminalOptions

--- @class OpenTerminal.Open
--- @field direction? OpenTerminalDirection

local function is_win_valid()
  return Terminal.win ~= nil and vim.api.nvim_win_is_valid(Terminal.win)
end

--- @param options OpenTerminal.Open
function M.open_terminal(options)
  if is_win_valid() then
    vim.api.nvim_win_close(Terminal.win, true)
    return
  end
  Terminal.create({
    direction = options.direction,
  })
end

--- @param options? OpenTerminalOptions
function M.setup(options)
  options = options or {}

  vim.api.nvim_create_user_command("OpenTerminal", function(args)
    M.open_terminal({
      direction = args.args,
    })
  end, {
    nargs = 1,
    complete = function()
      return { "below", "above", "left", "right", "float" }
    end,
  })
end

return M
