--- @class my.repeat
--- @field private _ui my.repeat._ui
--- @field private _state my.repeat._state
--- @field private _capture my.repeat._capture
--- @field private _replay my.repeat._replay
local M = vim._defer_require("my.repeat", {
  _ui = true,
  _state = true,
  _capture = true,
  _replay = true,
})

--- @class my.repeat.Opts

--- @type my.repeat.Opts
local default_config = {}
local _config = default_config

--- @class my.repeat.set_repeat.Opts
--- @field noremap? boolean

--- @param callback fun()|string
--- @param opts? my.repeat.set_repeat.Opts
function M.set_repeat(callback, opts)
  opts = opts or {}
  vim.validate("opts", opts, "table", true)
  vim.validate("callback", callback, { "string", "function" })
  local noremap = opts.noremap
  if type(callback) == "string" then
    M._capture.start()
    vim.api.nvim_feedkeys(callback, noremap and "ni" or "mi", false)
    vim.api.nvim_feedkeys(vim.keycode("<cmd>lua my['repeat']._capture.finish()<cr>"), "nt", false)
  elseif type(callback) == "function" then
    callback()
  end
end

--- @param _enable boolean?
function M.enable(_enable)
  vim.validate("enable", _enable, "boolean", true)
  local state = M._state
  _enable = _enable ~= false
  if state.enabled == _enable then
    return
  end
  state.enabled = _enable
  if state.enabled then
    M._capture.active()
    M._replay.enable(true)
    vim.api.nvim_create_user_command("MyRepeatHistory", function()
      M._ui.open()
    end, {
      nargs = 0,
    })
  else
    M._capture.deactive()
    M._replay.enable(false)
  end
end

--- @param callback fun(atom: vim.event.cmdatom.data): vim.event.cmdatom.data|nil
function M.patch(callback)
  vim.validate("callback", callback, "function")
  M._capture.patch(callback)
end

--- @param config my.repeat.Opts?
function M.config(config)
  config = config or {}
  vim.validate("config", config, "table", true)
  _config = vim.tbl_deep_extend("force", _config, config)
end

return M
