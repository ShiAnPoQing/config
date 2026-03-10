local Window = require("bufferman.ui.window")
local Buffer = require("bufferman.ui.buffer")

local M = {
  Shared = {
    state = true,
  },
  Window = Window,
  Buffer = Buffer,
}

function M:open(opt)
  local current_win = vim.api.nvim_get_current_win()
  self.Shared.state = false
  Buffer:create(opt)
  Window:create(Buffer.buf)
  self.Shared.OpenPost({ win = current_win })
end

function M:close()
  self.Shared.ClosePre()
  self.Shared.state = true
  Window:destory()
  Buffer:destory()
  self.Shared.ClosePost()
end

function M:update(flag, opt)
  if self.Shared.state then
    return
  end

  if flag == "window" then
    Buffer:update(opt)
    return
  end

  Buffer:update(opt)
  Window:update()
end

function M:register(register)
  self.Shared.OpenPost = register.OpenPost
  self.Shared.ClosePre = register.ClosePre
  self.Shared.ClosePost = register.ClosePost
  self.Shared.get_cursor_pos = register.get_cursor_pos

  Window.Shared = self.Shared
  Buffer.Shared = self.Shared

  local BufWinEnter = register.Buffer.events.BufWinEnter
  local WinEnter = register.Buffer.events.WinEnter
  local BufWriteCmd = register.Buffer.events.BufWriteCmd
  local WinClosed = register.Buffer.events.WinClosed
  local VimResized = register.Buffer.events.VimResized
  local OnEnter = register.Buffer.events.OnEnter

  local ctx = {
    Window = Window,
    Buffer = Buffer,
  }

  self.Shared.Buffer = {
    events = {
      BufWriteCmd = function(ev)
        return BufWriteCmd(ev, ctx)
      end,
      BufWinEnter = function(ev)
        return BufWinEnter(ev, ctx)
      end,
      WinEnter = function(ev)
        return WinEnter(ev, ctx)
      end,
      WinClosed = function(ev)
        return WinClosed(ev, ctx)
      end,
      VimResized = function(ev)
        return VimResized(ev, ctx)
      end,
      OnEnter = function()
        return OnEnter(ctx)
      end,
    },
    get_lines = register.Buffer.get_lines,
  }

  self.Shared.Window = {}
end

function M:state()
  return self.Shared.state
end

function M:get_info()
  return {
    buf = Buffer.buf,
    win = Window.win,
  }
end

return M
