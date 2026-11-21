--- @class my._win
--- @field cursor my._win.cursor

local submodules = {
  cursor = {
    scope = true,
  },
}

--- @class my.win
--- @field cursor my.win.cursor
--- @field [integer] my._win
local M = { _submodules = submodules }

setmetatable(M, {
  __index = function(t, k)
    if type(k) == "number" then
      local win = k
      if not vim.api.nvim_win_is_valid(win) then
        vim.notify(string.format("my.win[%d]: Invalid win", win), vim.log.levels.ERROR)
        return nil
      end
      vim.api.nvim_create_autocmd("WinClosed", {
        callback = function(ev)
          if ev.win == win then
            t[k] = nil
            return true
          end
        end,
      })
      t[k] = my.module.wrap_with_scope(win, M)
      return t[k]
    end
    if not submodules[k] then
      return
    end
    local name = string.format("%s.%s", "my.win", k)
    t[k] = require(name)
    return t[k]
  end,
})

return M
