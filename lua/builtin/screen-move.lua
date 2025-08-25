local M = {}
local api = vim.api
local Direction = {}
Direction.left = setmetatable({}, { __index = Direction })
Direction.right = setmetatable({}, { __index = Direction })
Direction.top = setmetatable({}, { __index = Direction })
Direction.bottom = setmetatable({}, { __index = Direction })
Direction.v_center = setmetatable({}, { __index = Direction })
Direction.h_center = setmetatable({}, { __index = Direction })

api.nvim_set_hl(0, "ScreenMoveKey", { fg = "#ff007c" })

--- @alias ScreenMoveDirection "left" | "right" | "top" | "bottom" | "h_center" | "v_center"

--- @param opts {
---   h: table<integer>;
---   j: table<integer>;
---   k: table<integer>;
---   l: table<integer>;
--- }
local function set_extmark(ns_id, opts)
  for key, value in pairs(opts) do
    api.nvim_buf_set_extmark(0, ns_id, value[1], 0, {
      virt_text_win_col = value[2],
      virt_text = { { key, "ScreenMoveKey" } },
    })
  end
  return function()
    api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
  end
end

local function on_key()
  return vim.fn.nr2char(vim.fn.getchar())
end

local function exchange_extmark_opts(extmark_opts)
  local new_opts = {}
  for key, value in pairs(extmark_opts) do
    if key:upper() == key then
      new_opts[key:lower()] = value
    else
      new_opts[key:upper()] = value
    end
  end
  return new_opts
end

function Direction:init(dir)
  local current_win = vim.api.nvim_get_current_win()
  local wininfo = vim.fn.getwininfo(current_win)[1]
  local cursor_row, _ = unpack(api.nvim_win_get_cursor(0))
  local virt_col = vim.fn.virtcol(".") - 1
  self.wininfo = wininfo
  self.virt_win_col = virt_col - wininfo.leftcol
  self.cursor_row = cursor_row
  self.count = vim.v.count
  self.Dir = Direction[dir]
  self.Dir:_init()
  self.ns_id = api.nvim_create_namespace("screen-move-extmark")
end

function Direction:action1()
  api.nvim_feedkeys(self.move_key, "n", false)
end

function Direction:action2(char)
  api.nvim_feedkeys(self.move_key .. self.count .. char, "n", false)
end

function Direction:action3()
  local key = self:get_move_view_key()
  api.nvim_feedkeys(key, "n", false)
end

function Direction:action4(char)
  local key = self:get_move_view_key()
  api.nvim_feedkeys(key .. self.count .. char:lower(), "n", false)
end

function Direction:action5()
  api.nvim_buf_clear_namespace(0, self.ns_id, 0, -1)
  self.extmark_opts = exchange_extmark_opts(self.extmark_opts)
  set_extmark(self.ns_id, self.extmark_opts)
  vim.cmd.redraw()
  self:on_key()
end

function Direction:main()
  local Dir = self.Dir

  if self.count == 0 then
    if Dir:at_boundary() then
      api.nvim_feedkeys(Dir.move_view_key, "n", false)
    else
      api.nvim_feedkeys(Dir.move_key, "n", false)
    end
    return
  end
  set_extmark(self.ns_id, Dir.extmark_opts)
  vim.cmd.redraw()
  Dir:on_key()
end

function Direction.left:_init()
  self.move_key = "g0"
  self.move_view_key = "zeg0"
  self.boundary = 0
  self.extmark_opts = {
    j = { self.cursor_row + self.count - 1, self.boundary },
    k = { self.cursor_row - self.count - 1, self.boundary },
    h = { self.cursor_row - 1, self.boundary },
  }
  self.a1 = { "h" }
  self.a2 = { "j", "k" }
  self.a3 = { "H" }
  self.a4 = { "J", "K" }
  self.a5 = { " " }
end

function Direction.right:_init()
  self.move_key = "g$"
  self.move_view_key = "zsg$"
  self.boundary = self.wininfo.width - self.wininfo.textoff - 1
  self.extmark_opts = {
    j = { self.cursor_row + self.count - 1, self.boundary },
    k = { self.cursor_row - self.count - 1, self.boundary },
    l = { self.cursor_row - 1, self.boundary },
  }
  self.a1 = { "l" }
  self.a2 = { "j", "k" }
  self.a3 = { "L" }
  self.a4 = { "J", "K" }
  self.a5 = { " " }
end

function Direction.top:_init()
  self.move_key = "H"
  self.move_view_key = "zbH"
  self.boundary = self.wininfo.topline - 1
  self.extmark_opts = {
    h = { self.boundary, self.virt_win_col - self.count },
    k = { self.boundary, self.virt_win_col },
    l = { self.boundary, self.virt_win_col + self.count },
  }
  self.a1 = { "k" }
  self.a2 = { "l", "h" }
  self.a3 = { "K" }
  self.a4 = { "L", "H" }
  self.a5 = { " " }
end

function Direction.bottom:_init()
  self.move_key = "L"
  self.move_view_key = "ztL"
  self.boundary = self.wininfo.botline - 1
  self.extmark_opts = {
    h = { self.boundary, self.virt_win_col - self.count },
    j = { self.boundary, self.virt_win_col },
    l = { self.boundary, self.virt_win_col + self.count },
  }
  self.a1 = { "j" }
  self.a2 = { "l", "h" }
  self.a3 = { "J" }
  self.a4 = { "L", "H" }
  self.a5 = { " " }
end

function Direction.v_center:_init()
  self.move_key = "M"
  self.move_view_key = ""
  self.boundary = math.floor((self.wininfo.botline - self.wininfo.topline) / 2 + self.wininfo.topline - 1)
  self.extmark_opts = {
    h = { self.boundary, self.virt_win_col - self.count },
    l = { self.boundary, self.virt_win_col + self.count },
    j = { self.boundary + self.count, self.virt_win_col },
    k = { self.boundary - self.count, self.virt_win_col },
    n = { self.boundary, self.virt_win_col },
  }
  self.a1 = { "n" }
  self.a2 = { "h", "l", "j", "k" }
  self.a3 = {}
  self.a4 = {}
  self.a5 = {}
end

function Direction.h_center:_init()
  self.move_key = "gm"
  self.move_view_key = ""
  self.boundary = math.ceil((self.wininfo.width - self.wininfo.textoff - 1) / 2)
  self.extmark_opts = {
    h = { self.cursor_row - 1, self.boundary - self.count },
    l = { self.cursor_row - 1, self.boundary + self.count },
    j = { self.cursor_row - 1 + self.count, self.boundary },
    k = { self.cursor_row - 1 - self.count, self.boundary },
    m = { self.cursor_row - 1, self.boundary },
  }
  self.a1 = { "m" }
  self.a2 = { "h", "l", "j", "k" }
  self.a3 = {}
  self.a4 = {}
  self.a5 = {}
end

function Direction.left:at_boundary()
  return self.virt_win_col == 0
end

function Direction.right:at_boundary()
  return self.virt_win_col == self.wininfo.width - self.wininfo.textoff - 1
end

function Direction.top:at_boundary()
  return self.cursor_row == self.wininfo.topline
end

function Direction.bottom:at_boundary()
  return self.cursor_row == self.wininfo.botline
end

function Direction.v_center:at_boundary()
  return false
end

function Direction.h_center:at_boundary()
  return false
end

function Direction:get_move_view_key()
  local key = self.move_view_key
  if self:at_boundary() then
    key = key:rep(self.count)
  else
    key = key:rep(self.count - 1)
    key = self.move_key .. key
  end
  return key
end

function Direction:on_key()
  local char = on_key()
  local action_map = {
    action1 = self.a1,
    action2 = self.a2,
    action3 = self.a3,
    action4 = self.a4,
    action5 = self.a5,
  }
  for method, action in pairs(action_map) do
    if vim.tbl_contains(action, char) then
      self[method](self, char)
    end
  end
  api.nvim_buf_clear_namespace(0, self.ns_id, 0, -1)
end

--- @param dir ScreenMoveDirection
function M.move(dir)
  Direction:init(dir)
  Direction:main()
end

return M
