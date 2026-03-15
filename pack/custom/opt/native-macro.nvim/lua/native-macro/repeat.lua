---@class NativeMacro.Repeat
local M = {
  last_register_name = nil,
}
local Record = require("native-macro.record")

function M:_repeat(register_name)
  if register_name == "@" then
    register_name = self.last_register_name
  else
    self.last_register_name = register_name
  end
  local history = Record.history[register_name]
  if history == nil then
    vim.api.nvim_feedkeys("@" .. register_name, "nx", true)
    return
  end

  local keys = history[#history]

  for i, value in ipairs(keys) do
    if i == #keys then
      return
    end
    vim.schedule(function()
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(value.key, true, true, true), "m", true)
    end)
  end
end

return M
