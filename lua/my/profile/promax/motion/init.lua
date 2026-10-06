--- @class my.profile.promax.motion
--- @field NORMAL my.profile.promax.motion.NORMAL
--- @field INSERT my.profile.promax.motion.INSERT
--- @field VISUAL my.profile.promax.motion.VISUAL
--- @field OPERATOR my.profile.promax.motion.OPERATOR
--- @field ['n'] my.profile.promax.motion.NORMAL
--- @field ['i'] my.profile.promax.motion.INSERT
--- @field ['x'] my.profile.promax.motion.VISUAL
--- @field ['o'] my.profile.promax.motion.OPERATOR
local M = my.util.defer_require("my.profile.promax.motion", {
  NORMAL = true,
  INSERT = true,
  VISUAL = true,
  OPERATOR = true,
  ["n"] = "NORMAL",
  ["i"] = "INSERT",
  ["x"] = "VISUAL",
  ["o"] = "OPERATOR",
})

return M
