local M = {}
local api = vim.api
local Direction = {}
Direction.left = setmetatable({}, { __index = Direction })
Direction.right = setmetatable({}, { __index = Direction })
Direction.top = setmetatable({}, { __index = Direction })
Direction.bottom = setmetatable({}, { __index = Direction })
Direction.Target = {}

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
  local wininfo = vim.fn.getwininfo()[1]
  local cursor_row, _ = unpack(api.nvim_win_get_cursor(0))
  local virt_col = vim.fn.virtcol(".") - 1
  self.wininfo = wininfo
  self.virt_win_col = virt_col - wininfo.leftcol
  self.cursor_row = cursor_row
  self.count = vim.v.count
  self.Dir = Direction[dir]
  self.Target = setmetatable(self.Target, { __index = self.Dir })
  self.Dir:_init()
  self.ns_id = api.nvim_create_namespace("screen-move-extmark")
end

function Direction.Target:t1()
  api.nvim_feedkeys(self.move_key, "n", false)
end

function Direction.Target:t2(char)
  api.nvim_feedkeys(self.move_key .. self.count .. char, "n", false)
end

function Direction.Target:t3()
  local key = self:get_move_view_key()
  api.nvim_feedkeys(key, "n", false)
end

function Direction.Target:t4(char)
  local key = self:get_move_view_key()
  api.nvim_feedkeys(key .. self.count .. char:lower(), "n", false)
end

function Direction.Target:t5()
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
  self.targets = {
    j = function(char)
      self.Target:t2(char)
    end,
    k = function(char)
      self.Target:t2(char)
    end,
    h = function()
      self.Target:t1()
    end,
    H = function()
      self.Target:t3()
    end,
    J = function(char)
      self.Target:t4(char)
    end,
    K = function(char)
      self.Target:t4(char)
    end,
    [" "] = function()
      self.Target:t5()
    end,
  }
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
  self.targets = {
    j = function(char)
      self.Target:t2(char)
    end,
    k = function(char)
      self.Target:t2(char)
    end,
    l = function()
      self.Target:t1()
    end,
    L = function()
      self.Target:t3()
    end,
    J = function(char)
      self.Target:t4(char)
    end,
    K = function(char)
      self.Target:t4(char)
    end,
    [" "] = function()
      self.Target:t5()
    end,
  }
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
  self.targets = {
    h = function(char)
      self.Target:t2(char)
    end,
    l = function(char)
      self.Target:t2(char)
    end,
    k = function()
      self.Target:t1()
    end,
    H = function(char)
      self.Target:t4(char)
    end,
    L = function(char)
      self.Target:t4(char)
    end,
    K = function()
      self.Target:t3()
    end,
    [" "] = function()
      self.Target:t5()
    end,
  }
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

  self.targets = {
    h = function(char)
      self.Target:t2(char)
    end,
    l = function(char)
      self.Target:t2(char)
    end,
    j = function()
      self.Target:t1()
    end,
    H = function(char)
      self.Target:t4(char)
    end,
    L = function(char)
      self.Target:t4(char)
    end,
    J = function()
      self.Target:t3()
    end,
    [" "] = function()
      self.Target:t5()
    end,
  }
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
  if not self.targets[char] then
    return
  end
  self.targets[char](char)
  api.nvim_buf_clear_namespace(0, self.ns_id, 0, -1)
end

--- @param dir ScreenMoveDirection
function M.move(dir)
  Direction:init(dir)
  Direction:main()
end

return M
