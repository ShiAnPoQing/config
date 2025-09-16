local M = {}
local Terminal = require("open-terminal.terminal")

--- @class OpenTerminalOptions
--- @field direction? "below" | "above" | "left" | "right" | "float"

--- @class OpenTerminal.Open
--- @field direction? "below" | "above" | "left" | "right" | "float"

--- @param options OpenTerminal.Open
function M.open_terminal(options)
  if not Terminal.win then
    Terminal.create({
      direction = options.direction,
    })
    return
  end

  if not vim.api.nvim_win_is_valid(Terminal.win) then
    Terminal.create({
      direction = options.direction,
    })
  else
    vim.api.nvim_win_close(Terminal.win, true)
  end
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
