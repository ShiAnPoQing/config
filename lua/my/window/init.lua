--- @class my.window
--- @field float my.window.float
--- @field float fun(file: string)
local M = vim._defer_require("my.window", {
  float = ..., --- @module 'my.window.float'
})

--- @class Window: my.Class<nil>
local Window = my.class()

function Window:init(age)
  self.age = age
end

--- @class LastStatus: my.Class<nil>
--- @overload fun(opts: boolean): LastStatus
local LastStatus = my.class()

function LastStatus:init(p) end

M.LastStatus = LastStatus

return M
