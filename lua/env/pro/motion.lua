--- @class my.env.pro.motion
--- @class my.env.pro.motion
--- @field NORMAL my.env.pro.motion.NORMAL
--- @field INSERT my.env.pro.motion.INSERT
--- @field VISUAL my.env.pro.motion.VISUAL
--- @field OPERATOR my.env.pro.motion.OPERATOR
--- @field ['n'] my.env.pro.motion.NORMAL
--- @field ['i'] my.env.pro.motion.INSERT
--- @field ['x'] my.env.pro.motion.VISUAL
--- @field ['o'] my.env.pro.motion.OPERATOR
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
