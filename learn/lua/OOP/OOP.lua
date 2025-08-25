local ClassName1 = { name = "类名", age = 0 } -- 创建一个表作为类

function ClassName1:new(opts)
  local obj = {} -- 创建一个新的空表作为对象
  setmetatable(obj, self) -- 设置元表，使对象继承类的方法
  self.__index = self -- 设置索引元方法
  -- 初始化对象的属性
  -- obj:init(...) -- 可选：调用初始化函数
  obj.name = opts.name -- 初始化属性
  obj.age = opts.age -- 初始化属性
  return obj
end

function ClassName1:speack()
  print("我是" .. self.name .. "， 我今年" .. self.age .. "岁了, " .. "我说话了")
end

local obj = ClassName1:new({
  name = "张三",
  age = 23,
})

obj:speack()

print(obj.name, ClassName1.name)
print(obj.age, ClassName1.age)

local ClassName2 = {}

function ClassName2:new(o, opts)
  o = o or {}
  setmetatable(o, self)
  self.__index = self
  o:init(opts)
  return o
end

function ClassName2:speack()
  print("我是" .. self.name .. "， 我今年" .. self.age .. "岁了, " .. "我说话了")
end

local obj2 = ClassName2:new({
  init = function(self, opts)
    self.name = opts.name
    self.age = opts.age
  end,
}, {
  name = "张三",
  age = 23,
})

obj2:speack()
