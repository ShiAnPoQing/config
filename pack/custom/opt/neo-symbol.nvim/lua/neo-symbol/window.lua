local M = {}

--- @class NeoSymbol.Window.Options
--- @field position "left" | "right" | "above" | "below"

--- @param options NeoSymbol.Window.Options
function M:create(options)
  if self.buf and self.win then
    return
  end

  self.buf = vim.api.nvim_create_buf(false, true)
  self.win = vim.api.nvim_open_win(self.buf, false, {
    win = -1,
    split = options.position,
  })
end

function M:close()
  pcall(vim.api.nvim_win_close, self.win, true)
  pcall(vim.api.nvim_buf_delete, self.buf, {
    force = true,
  })
  self.buf = nil
  self.win = nil
end

return M
