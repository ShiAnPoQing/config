---@class NativeMacro.Command
local M = {}

function M:init(opt)
  vim.api.nvim_create_autocmd("CmdlineEnter", {
    callback = function(arg)
      self.command = arg.match
      opt.enter()
      return true
    end,
  })
  vim.api.nvim_create_autocmd("CmdlineLeave", {
    callback = function()
      opt.leave({ command = self.command })
      self.command = nil
      return true
    end,
  })
end

function M:create(typed)
  if not self.command then
    return false
  end
  self.command = self.command .. typed
  return true
end

return M
