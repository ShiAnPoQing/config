local M = {}
local Float = require("custom.plugins.repeat.float")
local Record = require("custom.plugins.repeat.record")

local RepeatKeymapQueue = {}

--- @class RepeatNeed
--- @field keymap string
--- @field callback fun():nil
--- @field type string

--- @param need RepeatNeed
function M.Repeat(need)
  table.insert(RepeatKeymapQueue, need.keymap)
end

function M.RecordStart()
  if M.state then
    return
  end
  Record.start()
  local win, buf = Float.createFloat()
end

function M.RecordEnd() end

function M.setup()
  vim.api.nvim_create_user_command("RepeatHistory", function() end, {})
  vim.api.nvim_create_user_command("RepeatStart", function()
    M.RecordStart()
  end, {})
  vim.api.nvim_create_user_command("RepeatEnd", function()
    M.RecordEnd()
  end, {})
end

return M
