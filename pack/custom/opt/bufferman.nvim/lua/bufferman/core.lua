local M = {}
local UI = require("bufferman.ui")
local MG = require("bufferman.manage")

function M.toggle()
  if not UI:state() then
    UI:close()
    return
  end

  UI:open()
end

UI:register({
  OpenPost = function(ctx)
    MG:init({ win = ctx.win })
  end,
  ClosePre = function() end,
  ClosePost = function()
    MG:clean()
  end,
  get_cursor_pos = function()
    return { MG.current_buf_index, 0 }
  end,
  Buffer = {
    get_lines = function()
      return MG:get_buffer_names()
    end,
    events = {
      BufWriteCmd = function()
        MG:update()
        return true
      end,
      WinClosed = function()
        if not UI:state() then
          M.toggle()
        end
        return true
      end,
      VimResized = function()
        UI.Window:resize()
      end,
      WinEnter = function() end,
      BufWinEnter = function(ev)
        if ev.buf == UI:get_info().buf then
          return
        end
        MG:init({ win = nil })
      end,
      OnEnter = function()
        MG:switch()
      end,
    },
  },
  Window = {},
})

MG:register({
  get_ui_info = function()
    return UI:get_info()
  end,
  OnUpdate = function()
    UI:update()
  end,
  OnSwitch = function()
    UI:update("window")
  end,
})

return M
