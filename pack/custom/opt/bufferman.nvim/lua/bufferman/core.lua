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
  get_cursor_pos = function()
    local index = MG:get_current_index()
    if not index then
      return
    end
    return { index, 0 }
  end,
  OpenPre = function()
    MG:init()
  end,
  OpenPost = function()
    MG:update()
  end,
  ClosePre = function() end,
  ClosePost = function()
    MG:clean()
  end,
  Buffer = {
    get_files = function()
      return MG:get_buffer_data()
    end,
    events = {
      BufWriteCmd = function()
        MG:update("diff")
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
      BufWinEnter = function(ev)
        if ev.file == "" then
          return
        end
        if vim.fn.fnamemodify(ev.file, ":t") == "Bufferman" then
          return
        end

        -- vim.print("BufWinEnter")
        MG:init()
        MG:update()
      end,
      DirChanged = function()
        MG:update()
      end,
      OnEnter = function()
        MG:switch()
      end,
    },
  },
  Window = {},
})

MG:register({
  get_lines = function()
    return UI:get_lines()
  end,
  OnUpdate = function()
    UI:update()
  end,
  OnSwitch = function()
    UI:update("window")
  end,
})

return M
