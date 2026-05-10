--[[
变量：局部变量和全局变量
--]]

--[[
变量声明：
  stat ::= local attnamelist [`=` explist]
  stat ::= global attnamelist [`=` explist]
  stat ::= global [attrib] `*`

  attnamelist ::= [attrib] Name [attrib] {',' Name [attrib]}
  attrib ::= `<` const | close `>`

- 局部变量和全局变量可以在块内的任何地方声明

- 变量声明的作用域从声明后的第一条语句开始，持续到包含该声明的最内层块的最后一个非空语句（空语句是标签和空语句。）

- 声明会遮蔽在声明点上下文中具有相同名称的任何声明（在此遮蔽内部，该名称的任何外部声明均无效）
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

- 声明可以包含初始化
  - 如果没有初始化，局部变量用 nil 初始化，全局变量保持不变
    local X;
    print(X) -- nil

    Y = 1
    global Y, print;
    print(Y) -- 1

  - 如果有初始化，则会进行多重赋值相同的调整
    local A, B, C = 1, 2
    print(C) -- nil
    对于全局变量，如果变量已定义（即，它具有非 nil 值），初始化将引发运行时错误
      Y = 1;
      global Y = 2; 
      运行时错误: global 'Y' already defined
- 对于全局变量，任何声明的效果仅限于语法（除了可选的赋值）

local A, B, C = 1, 2, 3
local <const>A<const>, B<const>, C<const> = 1, 2, 3
gloabl A, B, C = 1, 2, 3
global <const>A<const>, B<const>, C<const> = 1, 2, 3
global *
global<const> *

前缀属性应用于列表中的所有名称；后缀属性应用于其特定名称。
有两种可能的属性：
  - const: 声明一个常量或只读变量，即不能用作赋值左侧的变量；
  - close: 声明一个待关闭变量。
      只有局部变量可以具有 close 属性。
      变量列表最多可以包含一个待关闭变量。

所有代码块都以隐式声明 global * 开始，但此序言声明在任何其他 global 声明的作用域内失效

X = 1
global Y;
Y = 1
X -- Variable 'X' is not declared

- 使用全局声明或不以 global * 开头的程序可以自由读写任何全局变量；

  X = 1
  X = 2

- 以 global<const> * 开头的程序可以自由只读访问任何全局变量；

  X = 1
  global<const> *
  print(X)
  X = 1 -- Error

- 以任何其他全局声明（例如，global none）开头的程序只能引用已声明的变量。

  global none
  none = 1
  X -- Variable 'X' is not declared
--]]

--[[
变量赋值：Lua 允许多重赋值

  stat ::= varlist ‘=’ explist
  varlist ::= var {‘,’ var}
  explist ::= exp {‘,’ exp}

在赋值之前，值列表会根据变量列表的长度进行调整

--]]
