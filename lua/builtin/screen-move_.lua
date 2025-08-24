local M = {}
local api = vim.api
local Direction = {}
local Left = setmetatable({}, { __index = Direction })

api.nvim_set_hl(0, "ScreenMoveKey", { fg = "#ff007c" })

local function set_extmark(ns_id, opts) end

function Direction:_init()
  local wininfo = vim.fn.getwininfo()[1]
  local cursor_row, _ = unpack(api.nvim_win_get_cursor(0))
  local virt_col = vim.fn.virtcol(".") - 1
  self.wininfo = wininfo
  self.virt_win_col = virt_col - wininfo.leftcol
  self.cursor_row = cursor_row
  self.count = vim.v.count
  self.ns_id = api.nvim_create_namespace("screen-move-extmark")
end

function Direction:main()
  if self.count == 0 then
    if self:at_boundary() then
      api.nvim_feedkeys(self.move_view_key, "n", false)
    else
      api.nvim_feedkeys(self.move_key, "n", false)
    end
    return
  end
  set_extmark(self.ns_id, self.extmark_opts)
  vim.cmd.redraw()
  self:on_key()
end

function Left:init()
  self:_init()
  self.move_key = "g0"
  self.move_view_key = "zeg0"
  self.boundary = 0
  self.extmark_opts = {
    j = { self.cursor_row + self.count - 1, self.boundary },
    k = { self.cursor_row - self.count - 1, self.boundary },
    h = { self.cursor_row - 1, self.boundary },
  }
  vim.print(self)
end

--- @param dir ScreenMoveDirection
function M.move(dir)
  Left:init()
end

return M
