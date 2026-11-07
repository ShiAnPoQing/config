--- @diagnostic disable: invisible
--- @class my._atom._capture.core
local M = {}

--- @class my._atom._capture.CaptureTask
--- @field id my._atom.Capturer
--- @field callback? fun(any)
--- @field config my._atom._capture.CaptureConfig

--- @class my._atom._capture.CaptureConfig
--- @field patch? fun(data: my.CmdAtom): my.CmdAtom|nil
--- @field filter? fun(data: my.CmdAtom): boolean

--- @type my._atom._capture.CaptureTask[]
local start_queue = {}
--- @type my._atom._capture.CaptureTask[]
local stop_queue = {}

--- @type table<my._atom.Capturer, my._atom._capture.CaptureConfig|nil>
local started_captures = {}

local enabled
local CmdAtomId
local CmdAtomEnter

local signals = {
  START = "<Plug>my._atom.Capturer.signal.start",
  STOP = "<Plug>my._atom.Capturer.signal.stop",
}

local function enable_signal()
  vim.keymap.set({ "n", "x", "i" }, signals.START, function() end)
  vim.keymap.set({ "n", "x", "i" }, signals.STOP, function() end)
end

local function disable_signal()
  vim.keymap.del({ "n", "x", "i" }, signals.START)
  vim.keymap.del({ "n", "x", "i" }, signals.STOP)
end

--- @param singal "START"|"STOP"
local function send_signal(singal)
  vim.api.nvim_feedkeys(vim.keycode(signals[singal]), "nt", false)
end

--- @param data vim.event.cmdatom.data
--- @return "START"|"STOP"|nil
local function get_signal(data)
  local signal = vim.fn.keytrans(data.lhs)
  if signal == signals.START then
    return "START"
  end
  if signal == signals.STOP then
    return "STOP"
  end
end

--- @param immediately boolean|nil
local function start_capture(immediately)
  immediately = immediately ~= false
  local task
  if immediately then
    task = table.remove(start_queue) --[[@as my._atom._capture.CaptureTask]]
  else
    task = table.remove(start_queue, 1) --[[@as my._atom._capture.CaptureTask]]
  end
  if type(task.callback) == "function" then
    task.callback()
  end
  started_captures[task.id] = {
    patch = task.config.patch or task.id.patch,
    filter = task.config.filter or task.id.filter,
  }
end

--- @param immediately boolean|nil
local function stop_capture(immediately)
  immediately = immediately ~= false
  local task
  if immediately then
    task = table.remove(stop_queue) --[[@as my._atom._capture.CaptureTask]]
  else
    task = table.remove(stop_queue, 1) --[[@as my._atom._capture.CaptureTask]]
  end
  if type(task.callback) == "function" then
    task.callback(task.id.capture)
  end
  started_captures[task.id] = nil
end

--- @param data my.CmdAtom
local function capture(data)
  for capturer, _ in pairs(started_captures) do
    local _data = vim.tbl_deep_extend("force", data, {})
    local config = started_captures[capturer]
    local patch = config.patch
    local filter = config.filter
    if patch then
      _data = patch(_data) or _data
    end
    if
      not filter or filter and filter(_data --[[@as my.CmdAtom]])
    then
      table.insert(capturer.capture.atoms, _data)
    else
    end
  end
end

function M.is_enabled()
  return enabled
end

local function _enable()
  if CmdAtomId then
    return
  end
  enable_signal()
  CmdAtomId = vim.api.nvim_create_autocmd("CmdAtom", {
    callback = function(ev)
      CmdAtomEnter = true
      local data = ev.data
      data.buf = ev.buf
      local signal = get_signal(data)
      if signal == "START" then
        start_capture()
        CmdAtomEnter = nil
        return
      end
      if signal == "STOP" then
        stop_capture()
        CmdAtomEnter = nil
        return
      end
      vim.api.nvim_exec_autocmds("User", { pattern = "CmdAtomBefore" })
      capture(data)
      vim.api.nvim_exec_autocmds("User", { pattern = "CmdAtomAfter" })
      CmdAtomEnter = nil
    end,
  })
end

local function disable()
  if not CmdAtomId then
    return
  end
  disable_signal()
  vim.api.nvim_del_autocmd(CmdAtomId)
  CmdAtomId = nil
end

--- @param enable boolean|nil
function M.enable(enable)
  vim.validate("enable", enable, "boolean", true)
  enable = enable ~= false
  if enable == enabled then
    return
  end
  enabled = enable
  if enable then
    _enable()
  else
    disable()
  end
end

--- @param capturer my._atom.Capturer
--- @param callback fun()|nil
--- @param config my._atom._capture.CaptureConfig
function M.start(capturer, callback, config)
  --- @type my._atom._capture.CaptureTask
  local task = {
    id = capturer,
    callback = callback,
    config = config,
  }
  table.insert(start_queue, task)
  if not CmdAtomEnter then
    send_signal("START")
  else
    start_capture(true)
  end
end

--- @param capturer my._atom.Capturer
--- @param callback fun(capture: my.Atom)|nil
function M.stop(capturer, callback)
  --- @type my._atom._capture.CaptureTask
  local pending = {
    id = capturer,
    callback = callback,
    config = {},
  }
  table.insert(stop_queue, pending)
  if not CmdAtomEnter then
    send_signal("STOP")
  else
    stop_capture()
  end
end

return M
