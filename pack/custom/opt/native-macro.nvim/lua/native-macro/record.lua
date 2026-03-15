---@class NativeMacro.Record
---@field ns_id integer
---@field history {[string]: NativeMacro.Record.Segment[][]}
local M = {
  history = {},
}

local Command = require("native-macro.command")

---@class NativeMacro.Record.Segment
---@field type "keymap" | "command"
---@field key string

---@type NativeMacro.Record.Segment[]
local current_keys
---@type string
local current_register_name

function M:start()
  Command:init({
    enter = function()
      table.remove(current_keys, #current_keys)
    end,
    leave = function(ctx)
      current_keys[#current_keys + 1] = {
        type = "command",
        key = ctx.command,
      }
    end,
  })
  self.ns_id = self.ns_id or vim.api.nvim_create_namespace("native-record")
  current_register_name = vim.fn.reg_recording()
  current_keys = {}
  vim.on_key(function(_, typed)
    typed = vim.fn.keytrans(typed)
    if Command:create(typed) then
      return
    end
    if typed ~= "" then
      current_keys[#current_keys + 1] = {
        type = "keymap",
        key = typed,
      }
    end
  end, self.ns_id)
end

function M:stop()
  vim.on_key(nil, self.ns_id)
  if self.history[current_register_name] then
    if #self.history[current_register_name] > 20 then
      self.history[current_register_name] = nil
    end
  end
  local history = self.history[current_register_name]
  if history == nil then
    history = {}
    self.history[current_register_name] = history
  end
  table.insert(history, current_keys)
end

return M
