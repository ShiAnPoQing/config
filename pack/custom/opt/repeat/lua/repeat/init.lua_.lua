local M = {}

M.tick = -1

function M:update_tick()
  self.tick = vim.b.changedtick
end

function M:fallback()
  local count = vim.v.count1
  vim.api.nvim_feedkeys(count .. ".", "nx", false)
  self:update_tick()
end

function M:run()
  if self.repeat_callback == nil then
    local count = vim.v.count1
    for i = 1, count do
      self:fallback()
    end
    return
  end

  if self.tick == vim.b.changedtick then
    if self.repeat_callback.manual_update then
      self.repeat_callback.callback(function()
        self:update_tick()
      end)
    else
      self.repeat_callback.callback()
      self:update_tick()
    end
  else
    self:fallback()
    self.repeat_callback = nil
  end
end

function M:set(callback, manual_update)
  self.repeat_callback = {
    callback = callback,
    manual_update = manual_update,
  }
  self:update_tick()
end

function M.setup(opts)
  vim.keymap.set("n", ".", function()
    M:run()
  end)
end

return M
