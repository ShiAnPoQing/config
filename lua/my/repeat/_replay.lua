local capture = require("my.repeat._capture")

--- @class (private) my.repeat._replay
local M = {}
local enabled = false

--- @param enable boolean?
function M.enable(enable)
  vim.validate("enable", enable, "boolean", true)
  enable = enable ~= false
  if enabled == enable then
    return
  end
  enabled = enable
  if enabled then
    vim.keymap.set("n", ".", function()
      M.replay()
    end)
  else
    vim.keymap.del("n", ".")
  end
end

function M.replay()
  if not enabled then
    return
  end
  local cap = capture.get_last_capture()
  if not cap or #cap == 0 then
    return
  end
  for _, atom in ipairs(cap) do
    vim.api.nvim_feedkeys(atom.keys or atom.lhs, atom.keys and "n" or "m", false)
  end
end

return M
