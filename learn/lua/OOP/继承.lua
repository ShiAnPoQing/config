---@class Base
---@field name string
local Base = {}
Base.__index = Base

---@param name string
---@return Base
function Base:new(name)
  local obj = {}
  setmetatable(obj, self)
  obj.name = name
  return obj
end

function Base:say() end

---@class Child: Base
---@field age number
local Child = setmetatable({}, { __index = Base })
Child.__index = Child

function Child:new(name, age)
  local obj = Base.new(self, name)
  obj.age = age
  return obj
end

function Child:say() end

local C1 = Child:new("luoqing", 18)
vim.print(getmetatable(C1))
vim.print(C1)
