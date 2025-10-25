local M = {}

local visual_hl = vim.api.nvim_get_hl(0, { name = "Visual" })
vim.api.nvim_set_hl(0, "CustomMagicVisual", {
  fg = "#cdcdcd",
  bg = "#333738",
})
vim.api.nvim_set_hl(0, "CustomMagicNextKey", {
  fg = "#ff007c",
})
vim.api.nvim_set_hl(0, "CustomMagicNextKey1", {
  fg = "#00dfff",
})
vim.api.nvim_set_hl(0, "CustomMagicNextKey2", {
  fg = "#2b8db3",
})
vim.api.nvim_set_hl(0, "CustomMagicUnmatched", {
  fg = "#666666",
})
vim.api.nvim_set_hl(0, "CustomMagicNextKeyInVisual", {
  fg = "#ff007c",
  bg = visual_hl.bg,
})
vim.api.nvim_set_hl(0, "CustomMagicNextKey1InVisual", {
  fg = "#00dfff",
  bg = visual_hl.bg,
})
vim.api.nvim_set_hl(0, "CustomMagicNextKey2InVisual", {
  fg = "#2b8db3",
  bg = visual_hl.bg,
})

--- @param registers table<EyeTrack.Key.RegisterOptions>
M.main = function(registers)
  local core = require("eye-track.core.key.core")
  core:init()
  core:compute(#registers)
  for _, value in ipairs(registers) do
    core:register(value)
  end
  core:on_key()
end

return M
