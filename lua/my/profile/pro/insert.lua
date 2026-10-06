--- @class my.profile.pro.insert
--- @field NORMAL my.profile.pro.insert.NORMAL
--- @field n my.profile.pro.insert.NORMAL
local M = my.util.defer_require("my.profile.pro.insert", {
  NORMAL = true,
  ["n"] = "NORMAL",
})

return M
