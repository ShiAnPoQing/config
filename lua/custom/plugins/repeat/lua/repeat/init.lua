local M = {}

M.tick = -1

function M:update_tick()
  self.tick = vim.b.changedtick
end

function M:fallback()
  vim.api.nvim_feedkeys(".", "nx", false)
  self:update_tick()
end

function M:run()
  if self.repeat_callback == nil then
    self:fallback()
    return
  end

  if self.tick == vim.b.changedtick then
    self.repeat_callback()
    self:update_tick()
  else
    self:fallback()
    self.repeat_callback = nil
  end
end

function M:set(callback)
  self.repeat_callback = callback
  self.tick = vim.b.changedtick
end

function M.setup(opts)
  vim.keymap.set("n", ".", function()
    M:run()
  end)
end

return M
