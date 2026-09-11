local M = {}

--- @class WindowResize.Config

--- @param config? WindowResize.Config
function M.setup(config)
  config = config or {}
end

--- @class WindowResize.Size
--- @field left? integer
--- @field right? integer
--- @field top? integer
--- @field bottom? integer

local ANCHORS = {
  left = true,
  right = true,
  top = true,
  bottom = true,
}

--- @return integer
local function get_status_height()
  local laststatus = vim.o.laststatus
  if laststatus == 3 then
    return 1
  end
  if laststatus == 0 then
    return 0
  end
  local wininfo = vim.fn.getwininfo(vim.api.nvim_get_current_win())[1]
  ---@diagnostic disable-next-line: undefined-field
  if wininfo.status_height == 1 then
    return 1
  end
  return 0
end

--- @param s integer
--- @param anchor "right"|"left"|"top"|"bottom"
local function nvim_win_resize(s, anchor)
  s = math.max(s, 0)
  if anchor == "right" or anchor == "left" then
    vim.api.nvim_win_resize(0, s, -1, {
      anchor = anchor,
    })
  elseif anchor == "top" or anchor == "bottom" then
    vim.api.nvim_win_resize(0, -1, s, {
      anchor = anchor,
    })
  end
end

--- @param side "left"|"right"|"top"|"bottom"
--- @return boolean|nil
local function has_no_space(side)
  local position = vim.api.nvim_win_get_position(0)
  if side == "left" then
    if position[2] == 0 then
      return true
    end
  elseif side == "right" then
    if position[2] == vim.o.columns - vim.api.nvim_win_get_width(0) then
      return true
    end
  elseif side == "top" then
    if position[1] == 0 then
      return true
    end
  elseif side == "bottom" then
    if position[1] == vim.o.lines - vim.api.nvim_win_get_height(0) - vim.o.cmdheight - get_status_height() then
      return true
    end
  end
end

--- @param size WindowResize.Size
--- @param count integer
local function normalize_size(size, count)
  local _size = {}
  for anchor, _ in pairs(ANCHORS) do
    if not size[anchor] or not type(size[anchor]) == "number" then
      _size[anchor] = 0
    else
      _size[anchor] = count * math.floor(size[anchor])
    end
  end
  return _size
end

--- @param size WindowResize.Size
function M.resize(size)
  -- local a = require("window-resize.tree"):new()
  -- vim.print(a.tree)
  vim.validate("size", size, "table")
  size = normalize_size(size, vim.v.count1)
  local top_no_space = has_no_space("top")
  local bottom_no_space = has_no_space("bottom")
  local left_no_space = has_no_space("left")
  local right_no_space = has_no_space("right")

  local resize_top = function()
    if size.top == 0 then
      return
    end

    if top_no_space then
      if size.bottom == 0 then
        size.bottom = -size.top
      end
      return
    end

    local height = vim.api.nvim_win_get_height(0)
    if size.top < 0 and height == vim.o.winminheight then
      nvim_win_resize(height + -size.top, "top")
      nvim_win_resize(height + size.top, "bottom")
      return
    end
    nvim_win_resize(height + size.top, "bottom")
  end

  local resize_bottom = function()
    if size.bottom == 0 then
      return
    end

    if bottom_no_space then
      if size.top == 0 then
        size.top = -size.bottom
      end
      return
    end

    local height = vim.api.nvim_win_get_height(0)
    nvim_win_resize(height + size.bottom, "top")
  end

  local resize_left = function()
    if size.left == 0 then
      return
    end

    if left_no_space then
      if size.right == 0 then
        size.right = -size.left
      end
      return
    end

    local width = vim.api.nvim_win_get_width(0)
    if size.left < 0 and width + size.left < vim.o.winminwidth then
      nvim_win_resize(width + -size.left, "left")
      nvim_win_resize(width + size.left, "right")
      return
    end
    nvim_win_resize(width + size.left, "right")
  end

  local resize_right = function()
    if size.right == 0 then
      return
    end

    if right_no_space then
      if size.left == 0 then
        size.left = -size.right
      end
      return
    end

    local width = vim.api.nvim_win_get_width(0)
    nvim_win_resize(width + size.right, "left")
  end

  local resizes = { resize_top, resize_bottom, resize_left, resize_right }

  if bottom_no_space and not top_no_space then
    resizes[1] = resize_bottom
    resizes[2] = resize_top
  end
  if right_no_space and not left_no_space then
    resizes[3] = resize_right
    resizes[4] = resize_left
  end
  for _, resize in ipairs(resizes) do
    resize()
  end
end

return M
