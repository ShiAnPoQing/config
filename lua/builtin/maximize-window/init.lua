local Maximize = require("builtin.maximize-window.maximize")
local max_size = Maximize:new("<C-W>|<C-W>_")
local equal_size = Maximize:new("<C-W>=")
local max_height = Maximize:new("<C-W>_")
local max_width = Maximize:new("<C-W>|")

local M = {}

M.max_size = function()
  max_size:exec()
end

M.equal_size = function()
  equal_size:exec()
end

M.max_height = function()
  max_height:exec()
end

M.max_width = function()
  max_width:exec()
end

return M
