local submodules = {
  NORMAL = true,
  INSERT = true,
  VISUAL = true,
  OPERATOR = true,
  COMMAND = true,
  ["n"] = "NORMAL",
  ["i"] = "INSERT",
  ["x"] = "VISUAL",
  ["o"] = "OPERATOR",
  ["c"] = "COMMAND",
  _shared = true,
}

--- @class my.env.pro.motion
--- @class my.env.pro.motion
--- @field NORMAL my.env.pro.motion.NORMAL
--- @field INSERT my.env.pro.motion.INSERT
--- @field VISUAL my.env.pro.motion.VISUAL
--- @field OPERATOR my.env.pro.motion.OPERATOR
--- @field COMMAND my.env.pro.motion.COMMAND
--- @field ['n'] my.env.pro.motion.NORMAL
--- @field ['i'] my.env.pro.motion.INSERT
--- @field ['x'] my.env.pro.motion.VISUAL
--- @field ['o'] my.env.pro.motion.OPERATOR
--- @field ['c'] my.env.pro.motion.COMMAND
local M = { _submodules = submodules }

setmetatable(M, {
  ---@param t table<string, any>
  ---@param k string
  __index = function(t, k)
    if not submodules[k] then
      return my._.motion[k]
    end
    -- alias
    if type(submodules[k]) == "string" then
      ---@diagnostic disable-next-line: cast-local-type
      k = submodules[k]
    end
    local name = string.format("%s.%s", "env.pro.motion", k)
    t[k] = require(name)
    return t[k]
  end,
})

return M
