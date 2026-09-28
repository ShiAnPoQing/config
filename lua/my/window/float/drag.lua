--- @class my.window.float.drag
local M = {}

local enabled = false
--- @type my.window.float.drag.config
local _config = {
  mouse = "<M-LeftMouse>",
}
local mouse_regex

local dragging = false
local start_row
local start_col
local dragging_win
local dragging_win_config

local function _enable()
  local mouse_key = _config.mouse:lower() --[[@as string]]
  local mouse_drag_key = mouse_key:gsub("mouse>$", "drag>")
  local mouse_release_key = mouse_key:gsub("mouse>$", "release>")
  vim.keymap.set("n", mouse_key, function()
    local win = vim.api.nvim_get_current_win()
    local config = vim.api.nvim_win_get_config(win)
    if config.relative == "" then
      return mouse_key
    end
    dragging_win_config = config
    dragging_win = win
    dragging = true
    local mouse = vim.fn.getmousepos()
    start_row = mouse.screenrow
    start_col = mouse.screencol
  end, { expr = true })
  vim.keymap.set("n", mouse_drag_key, function()
    if not dragging then
      return mouse_drag_key
    end
    local mouse = vim.fn.getmousepos()
    local drow = mouse.screenrow - start_row
    local dcol = mouse.screencol - start_col
    dragging_win_config.row = dragging_win_config.row + drow
    dragging_win_config.col = dragging_win_config.col + dcol
    my.window.float.move(dragging_win, drow, dcol)
    start_row = mouse.screenrow
    start_col = mouse.screencol
  end, { expr = true })

  vim.keymap.set("n", mouse_release_key, function()
    if not dragging then
      return mouse_release_key
    end
    dragging = false
  end, { expr = true })
end

--- @param enable boolean|nil
function M.enable(enable)
  vim.validate("enable", enable, "boolean", true)
  enabled = enable == nil and true or enable --[[@as boolean]]
  if enabled then
    _enable()
  end
end

function M.is_enabled()
  return enabled
end

--- @class my.window.float.drag.config
--- @field mouse string?

--- @param config my.window.float.drag.config?
function M.config(config)
  config = config or {}
  vim.validate("config", config, "table", true)
  vim.validate("config.mouse", config.mouse, "string", true)
  if config.mouse then
    mouse_regex = mouse_regex or vim.regex([[\c^<\%([scma]-\)*\(leftmouse\|rightmouse\)>$]])
    if not mouse_regex:match_str(config.mouse) then
      vim.api.nvim_echo(
        { { "my.window.float.drag.config.mouse: invalid mouse, fallback to default", "DiagnosticWarn" } },
        true
      )
    else
      _config.mouse = config.mouse
    end
  end
end

return M
