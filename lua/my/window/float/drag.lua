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

local function buf_win_enable(buf, win, mouse_key)
  vim.keymap.set("n", mouse_key, function()
    local config = vim.api.nvim_win_get_config(win)
    if config.relative == "" then
      return
    end
    dragging_win_config = config
    dragging_win = win
    dragging = true
    local mouse = vim.fn.getmousepos()
    start_row = mouse.screenrow
    start_col = mouse.screencol
  end, { buf = buf })

  vim.keymap.set("n", mouse_key:gsub("mouse>$", "drag>"), function()
    if not dragging then
      return
    end
    local mouse = vim.fn.getmousepos()
    local drow = mouse.screenrow - start_row
    local dcol = mouse.screencol - start_col
    dragging_win_config.row = dragging_win_config.row + drow
    dragging_win_config.col = dragging_win_config.col + dcol
    my.window.float.move(dragging_win, drow, dcol)
    start_row = mouse.screenrow
    start_col = mouse.screencol
  end, { buf = buf })
  vim.keymap.set("n", mouse_key:gsub("mouse>$", "release>"), function()
    dragging = false
  end, { buf = buf })
end

local function _enable()
  local mouse_key = _config.mouse:lower() --[[@as string]]
  for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
    local wins = vim.api.nvim_tabpage_list_wins(tab)
    for _, win in ipairs(wins) do
      if my.window.float.is_float(win) then
        local buf = vim.api.nvim_win_get_buf(win)
        buf_win_enable(buf, win, mouse_key)
      end
    end
  end

  vim.api.nvim_create_autocmd("WinNew", {
    callback = function(ev)
      vim.schedule(function()
        if not my.window.float.is_float(ev.win) then
          return
        end
        buf_win_enable(vim.api.nvim_win_get_buf(ev.win), ev.win, mouse_key)
      end)
    end,
  })
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
