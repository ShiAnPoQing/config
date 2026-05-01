local PL = require("lsp-layer.definition.pipeline")
local LC = require("lsp-layer.definition.location")
local FT = require("lsp-layer.definition.float")

---@class LspLayer.Definition.Response:LspLayer.Definition.Float
local M = {}

---@class LspLayer.Definition.Float
---@field float fun(self, opts)

M.__index = function(t, key)
  if type(PL[key]) == "function" then
    return function(...)
      PL[key](...)
      return t
    end
  end
  if type(LC[key]) == "function" then
    return function(...)
      local args = { ... }
      t:push(function()
        return LC[key](unpack(args))
      end)
      return t
    end
  end
  if type(FT[key]) == "function" then
    return function(...)
      local args = { ... }
      t:push(function()
        return FT[key](unpack(args))
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
