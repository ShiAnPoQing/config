local M = {}
local Buffer = require("buffer.buffer")

local function set_win_option(win)
  local win_option = {}
  for key, value in pairs(win_option) do
    vim.api.nvim_set_option_value(key, value, {
      win = win,
    })
  end
end

---@param config BufferWinConfig
function M.create(config)
  config = vim.tbl_deep_extend("force", M.config or {}, config)
  local win_config = {}
  if
    config.position == "right"
    or config.position == "left"
    or config.position == "above"
    or config.position == "below"
  then
    win_config.win = -1
    win_config.split = config.position
    win_config.width = config.width
    win_config.height = config.height
  elseif config.position == "float" then
    win_config = {
      relative = "editor",
      width = config.width,
      height = config.height,
      row = math.floor((vim.o.lines - config.height) / 2),
      col = math.floor((vim.o.columns - config.width) / 2),
      focusable = true,
      style = "minimal",
    }
  end
  M.win = vim.api.nvim_open_win(Buffer.buf, true, win_config)
  set_win_option(M.win)
  vim.api.nvim_create_autocmd("BufWriteCmd", {
    callback = function() end,
    buffer = Buffer.buf,
  })
  vim.api.nvim_create_autocmd("WinClosed", {
    callback = function()
      Buffer.delete()
      return true
    end,
    buffer = Buffer.buf,
  })
  Buffer.update()
end

---@param config BufferWinConfig
function M.init(config)
  M.config = config
end

function M.close()
  pcall(vim.api.nvim_win_close, M.win, true)
  M.win = nil
end

---@param config BufferWinConfig
function M.toggle(config)
  if M.win and vim.api.nvim_win_is_valid(M.win) then
    M.close()
    Buffer.delete()
    return
  end
  Buffer.create()
  M.create(config)
end

return M
