--- @class Gaze.LabelNode
--- @field parent Gaze.LabelNode|nil
--- @field children table<string, Gaze.LabelNode>
local M = {}
M.__index = M

--- @param parent Gaze.LabelNode|nil
function M:new(parent)
  local o = setmetatable({}, self)
  o.parent = parent
  o.children = {}
  return o
end

function M:gaze()
  local char = vim.fn.getcharstr()
  local next = self.children[char]

  if next then
    next:gaze()
  else
    self:gazed()
  end
end

function M:gazed() end

return M
