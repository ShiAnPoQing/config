local M = {}

--- @class RepeatSpec
--- @field callback fun()
--- @field type "operation" | "motion"

M.tick = -1

function M:update_tick()
  self.tick = vim.b.changedtick
end

function M:fallback()
  local count = vim.v.count1
  vim.api.nvim_feedkeys(count .. ".", "nx", false)
  self:update_tick()
end

function M:operation()
  if self.operation_repeat == nil then
    local count = vim.v.count1
    for i = 1, count do
      self:fallback()
    end
    return
  end

  if self.tick == vim.b.changedtick then
    self.operation_repeat()
  else
    self:fallback()
    self.operation_repeat = nil
  end
end

function M:motion()
  if type(self.motion_repeat) == "function" then
    self.motion_repeat()
  end
end

--- @param callback fun()
function M:set_operation(callback)
  self.operation_repeat = callback
  self:update_tick()
end

--- @param callback fun()
function M:set_motion(callback)
  self.motion_repeat = callback
end

--- @param spec RepeatSpec
function M:set(spec)
  if spec.type == "operation" then
    self:set_operation(spec.callback)
  elseif spec.type == "motion" then
    self:set_motion(spec.callback)
  end
end

return M
