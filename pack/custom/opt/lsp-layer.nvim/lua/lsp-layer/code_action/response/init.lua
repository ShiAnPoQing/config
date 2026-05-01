local SD = require("lsp-layer.code_action.response.schedule")
local TF = require("lsp-layer.code_action.response.transform")
local UI = require("lsp-layer.code_action.response.ui")

---@class LspLayer.CodeAction.Response: LspLayer.CodeAction.Transform, LspLayer.CodeAction.UI
local M = {}

---@alias LspLayer.CodeAction.Transform.Filter fun(self, filter:fun(x: lsp.CodeAction|lsp.Command, client_id: integer): boolean): LspLayer.CodeAction.Response

---@class LspLayer.CodeAction.Transform
---@field filter LspLayer.CodeAction.Transform.Filter

---@alias LspLayer.CodeAction.UI.Float fun(self, opts)
---@alias LspLayer.CodeAction.UI.Choice fun(self, opts)

---@class LspLayer.CodeAction.UI
---@field float LspLayer.CodeAction.UI.Float
---@field choice LspLayer.CodeAction.UI.Choice

M.__index = function(t, key)
  if type(SD[key]) == "function" then
    return function(...)
      SD[key](...)
      return t
    end
  end
  if type(TF[key]) == "function" then
    return function(...)
      local args = { ... }
      t:push(function()
        return TF[key](unpack(args))
      end)
      return t
    end
  end
  if type(UI[key]) == "function" then
    return function(...)
      local args = { ... }
      t:push(function()
        return UI[key](unpack(args))
      end)
    end
  end
end

function M:new()
  local o = setmetatable({}, self)
  o.queue = {}
  return o
end

return M
