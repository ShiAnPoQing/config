local ffi = require("ffi")
local C = ffi.C
ffi.cdef([[
  uint64_t display_tick;
]])

local winargs = {}

function _G.custom_statuscolumn()
  local win = vim.api.nvim_get_current_win()
  local args = winargs[win]
  local tick = C.display_tick

  if not args then
    args = { win = win, tick = 0 }
    winargs[win] = args
    tick = 1
  end

  args.lnum = vim.v.lnum
  args.relnum = vim.v.relnum
  args.virtnum = vim.v.virtnum

  if args.tick < tick then
    --
  end
  --
  return "1"
end

vim.o.statuscolumn = "%{%v:lua.custom_statuscolumn()%}"
