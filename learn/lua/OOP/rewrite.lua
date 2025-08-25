-- 定义动物类（Animal）
local Animal = { name = "Unknown" }

-- Animal 类的构造函数
function Animal:new(o, name)
  o = o or {} -- 如果没有传入对象，则创建一个新的空表
  setmetatable(o, self) -- 设置元表，使其继承 Animal 的方法
  self.__index = self -- 让对象可以访问 Animal 的方法
  o.name = name or "Unknown" -- 设置名称，默认为 "Unknown"
  return o
end

-- Animal 类的方法：叫声
function Animal:speak()
  print(self.name .. " makes a sound.")
end

-- 定义狗类（Dog），继承自 Animal
local Dog = Animal:new() -- Dog 继承 Animal 类

-- 重写狗类的构造函数
function Dog:new(o, name, breed)
  o = o or {} -- 如果没有传入对象，则创建一个新的空表
  setmetatable(o, self) -- 设置元表，使其继承 Dog 和 Animal 的方法
  self.__index = self -- 让对象可以访问 Dog 的方法
  o.name = name or "Unknown"
  o.breed = breed or "Unknown"
  return o
end

-- 重写狗类的叫声方法（重写 Animal 的 speak 方法）
function Dog:speak()
  print(self.name .. " barks.")
end

-- 创建 Animal 对象
local animal = Animal:new(nil, "Generic Animal")
animal:speak() -- 输出 "Generic Animal makes a sound."

-- 创建 Dog 对象
local dog = Dog:new(nil, "Buddy", "Golden Retriever")
dog:speak() -- 输出 "Buddy barks."
