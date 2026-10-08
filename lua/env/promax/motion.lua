--- @class my.env.promax.motion
--- @field NORMAL my.env.promax.motion.NORMAL
--- @field INSERT my.env.promax.motion.INSERT
--- @field VISUAL my.env.promax.motion.VISUAL
--- @field OPERATOR my.env.promax.motion.OPERATOR
--- @field ['n'] my.env.promax.motion.NORMAL
--- @field ['i'] my.env.promax.motion.INSERT
--- @field ['x'] my.env.promax.motion.VISUAL
--- @field ['o'] my.env.promax.motion.OPERATOR
local M = my.util.defer_require(..., {
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
