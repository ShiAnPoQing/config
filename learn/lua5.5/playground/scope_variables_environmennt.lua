
--[[
所有代码块都隐式声明 global * 开始

此声明在任何其他 global 声明的作用域内失效

  X = 1       -- Ok, global by default
  do
    global Y  -- voids the implicit initial declaration
    Y = 1     -- Ok, Y declared as global
    X = 1     -- Error, X not declared
  end
  X = 2       -- Ok, global by default again
--]]

--[[
变量声明的作用域从声明后的第一条语句开始，持续到包含该声明的最内层块的最后一个非空语句。（空语句是标签和空语句。）
声明会遮蔽在声明点上下文中具有相同名称的任何声明。在此遮蔽内部，该名称的任何外部声明均无效
  global print, x
  x = 10                -- global variable
  do                    -- new block
    local x = x         -- new 'x', with value 10
    print(x)            --> 10
    x = x+1
    do                  -- another block
      local x = x+1     -- another 'x'
      print(x)          --> 12
    end
    print(x)            --> 11
  end
  print(x)              --> 10  (the global one)
 --]]
