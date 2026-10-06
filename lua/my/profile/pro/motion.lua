--- @class my.profile.pro.motion
--- @class my.profile.pro.motion
--- @field NORMAL my.profile.pro.motion.NORMAL
--- @field INSERT my.profile.pro.motion.INSERT
--- @field VISUAL my.profile.pro.motion.VISUAL
--- @field OPERATOR my.profile.pro.motion.OPERATOR
--- @field ['n'] my.profile.pro.motion.NORMAL
--- @field ['i'] my.profile.pro.motion.INSERT
--- @field ['x'] my.profile.pro.motion.VISUAL
--- @field ['o'] my.profile.pro.motion.OPERATOR
local M = my.util.defer_require("my.profile.pro.motion", {
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
