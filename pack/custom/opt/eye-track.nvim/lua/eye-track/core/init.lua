local M = {}

vim.api.nvim_set_hl(0, "EyeTrackKey", {
  fg = "#ff007c",
  bold = true,
})
vim.api.nvim_set_hl(0, "EyeTrackNextKey", {
  fg = "#00dfff",
})

--- @param registers table<EyeTrack.Key.RegisterOptions>
M.main = function(registers)
  require("eye-track.core.key"):main(registers)
end

return M
