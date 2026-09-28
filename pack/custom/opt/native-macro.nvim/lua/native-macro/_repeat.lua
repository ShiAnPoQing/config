local Record = require("native-macro._record")

---@class NativeMacro._Repeat
local M = { last_reg = nil }

--- @param reg string
function M:_repeat(reg)
  if not reg then
    return
  end
  if reg == "@" then
    reg = self.last_reg
  else
    self.last_reg = reg
  end

  for _, atom in ipairs(Record.records[reg] or {}) do
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes(atom.keys or atom.lhs, true, false, true),
      atom.keys and "n" or "m",
      false
    )
  end
end

function M.init() end

return M
