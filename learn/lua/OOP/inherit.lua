-- 定义矩形类
local Rectangle = { area = 0, length = 0, breadth = 0 }

-- 创建矩形对象的构造函数
function Rectangle:new(o, length, breadth)
  o = o or {} -- 如果未传入对象，创建一个新的空表
  setmetatable(o, self) -- 设置元表，使其继承 Rectangle 的方法
  self.__index = self -- 确保在访问时能找到方法和属性
  o.length = length or 0 -- 设置长度，默认为 0
  o.breadth = breadth or 0 -- 设置宽度，默认为 0
  o.area = o.length * o.breadth -- 计算面积
  return o
end

-- 打印矩形的面积
function Rectangle:printArea()
  print("矩形面积为 ", self.area)
end

-- 定义正方形类，继承自矩形类
local Square = Rectangle:new() -- Square 继承 Rectangle 类

-- 重写构造函数（正方形的边长相等）
function Square:new(o, side)
  o = o or {} -- 如果未传入对象，创建一个新的空表
  setmetatable(o, self) -- 设置元表，使其继承 Rectangle 的方法
  self.__index = self -- 确保在访问时能找到方法和属性
  o.length = side or 0 -- 设置边长
  o.breadth = side or 0 -- 正方形的宽度和长度相等
  o.area = o.length * o.breadth -- 计算面积
  return o
end

-- 运行实例：
local rect = Rectangle:new(nil, 5, 10) -- 创建一个长为 5，宽为 10 的矩形
rect:printArea() -- 输出 "矩形面积为 50"

local square = Square:new(nil, 4) -- 创建一个边长为 4 的正方形
square:printArea() -- 输出 "矩形面积为 16"
