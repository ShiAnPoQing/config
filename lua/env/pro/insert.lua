--- @class my.env.pro.insert
--- @field NORMAL my.env.pro.insert.NORMAL
--- @field VISUAL my.env.pro.insert.VISUAL
--- @field x my.env.pro.insert.VISUAL
--- @field n my.env.pro.insert.NORMAL
local M = my.util.defer_require(..., {
  NORMAL = true,
  VISUAL = true,
  ["x"] = "VISUAL",
  ["n"] = "NORMAL",
})

return M
