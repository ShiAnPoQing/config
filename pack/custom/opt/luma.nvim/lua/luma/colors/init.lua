local light = require("luma.colors.light")
local dark = require("luma.colors.dark")

local M = {}

function M.load()
  local bg = vim.o.background

  if bg == "light" then
    return light
  end
  return dark
end

return M
