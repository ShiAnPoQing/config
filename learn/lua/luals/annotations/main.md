# Annotations

[官网](https://luals.github.io/wiki/annotations/)

## 注释格式

注释支持大部分 Markdown 语法 。

可以使用：

- 标题
- 粗体文本
- 斜体文本
- 删除线文本
- 有序列表
- 无序列表
- 块引用
- 代码
- 代码块
- 水平线
- 关联
- 图像

有很多方法可以在注释中添加换行符。

最安全的方法就是直接添加一行---，虽然这相当于段落分隔符，而不是换行符。

可以将以下方法添加到行尾：

- `HTML<br>`标签（推荐）
- `\n`换行符
- 两个尾随空格（可以通过格式化工具删除）
- Markdown 反斜杠`\`（不推荐 ）

## 引用符号

将鼠标悬停在 描述的值上将显示一个超链接，点击该链接将跳转到符号定义的位置。

```lua
---@alias MyCustomType integer

---Calculate a value using [my custom type](lua://MyCustomType)
```

## Lua 类型

```
nil
any
boolean
string
number
integer
function
table
thread
userdata
lightuserdata
```

?在类型（例如boolean?或）后添加问号 ( )number?相当于说boolean|nil或number|nil。

| 类型名称   | 语法格式                                 | 描述                               |
| ---------- | ---------------------------------------- | ---------------------------------- |
| 联合类型   | `TYPE_1 \| TYPE_2`                       | 表示可以是多种类型之一             |
| 数组       | `VALUE_TYPE[]`                           | 表示由特定类型元素组成的数组       |
| 元组       | `[VALUE_TYPE, VALUE_TYPE]`               | 表示固定长度和类型的数组           |
| 字典       | `{ [string]: VALUE_TYPE }`               | 表示字符串键到值的映射             |
| 键值表     | `table<KEY_TYPE, VALUE_TYPE>`            | 表示键值对集合                     |
| 对象字面量 | `{ key1: VALUE_TYPE, key2: VALUE_TYPE }` | 表示具有特定键的对象结构           |
| 函数       | `fun(PARAM: TYPE): RETURN_TYPE`          | 表示函数类型，包含参数和返回值类型 |

```lua
---@type (string | integer)[]
local myArray = {}
```

| 符号                       | 含义     | 说明                         |
| -------------------------- | -------- | ---------------------------- |
| `<value_name>`             | 必需值   | 表示必须提供的值             |
| `[value_name]`             | 可选值   | 表示方括号内的内容是可选的   |
| `[value_name...]`          | 可重复值 | 表示该值可以重复出现多次     |
| `value_name \| value_name` | 选择关系 | 表示左侧值或右侧值都是有效的 |

## `@alias`

```lua
---@alias <name> <type>
```

```lua
---@alias <name>
---| '<value>' [# description]
```

```lua
---@alias userID integer The ID of a user
```

```lua
---@alias modes "r" | "w"
```

```lua
---@alias DeviceSide
---| '"left"' # The left side of the device
---| '"right"' # The right side of the device
---| '"top"' # The top side of the device
---| '"bottom"' # The bottom side of the device
---| '"front"' # The front side of the device
---| '"back"' # The back side of the device

---@param side DeviceSide
local function checkSide(side) end
```

```lua
local A = "Hello"
local B = "World"

---@alias myLiteralAlias `A` | `B`

---@param x myLiteralAlias
function foo(x) end
```

```lua
local A = "Hello"
local B = "World"

---@alias myLiteralAlias `A` | `B`

---@param x myLiteralAlias
function foo(x) end
```

## `@as`

无法使用 `---@as <type>` 来添加此注释，必须像 `--[[@as <type>]]` 那样进行。

```lua
--[[@as <type>]]
```

```lua
---@param key string Must be a string
local function doSomething(key) end

local x = nil

doSomething(x --[[@as string]])
```

## `@async`

将函数标记为异步函数。

当 `hint.await` 为 `true` 时，标有 `@async` 的函数在调用时会在其旁边显示 `await` 提示。

用于 `await` 组的诊断。

```lua
---@async
---Perform an asynchronous HTTP GET request
function http.get(url) end
```

## `@cast`

将变量转换为一种或多种不同的类型

```
---@cast <value_name> [+|-]<type|?>[,[+|-]<type|?>...]
```

```lua
---@type integer | string
local x

---@cast x string
print(x) --> x: string
```

```lua
---@type integer
local x

---@cast x +boolean
print(x) --> x: integer | boolean
```

```lua
---@type integer|string
local x

---@cast x -integer
print(x) --> x: string
```

```lua
---@type string
local x --> x: string

---@cast x +boolean, +number
print(x) --> x:string | boolean | number
```

```lua
---@type string
local x

---@cast x +?
print(x) --> x:string?
```

## `@class`

定义一个类。

可以与 `@field` 一起使用来定义表结构。

定义类后，它可以用作参数、返回值等的类型。

类还可以继承一个或多个父类。

将类标记为 (exact) 意味着在定义之后无法注入字段。

```lua
---@class [(exact)] <name>[: <parent>[, <parent>...]]
```

```lua
---@class Car
local Car = {}
```

```lua
---@class Vehicle
local Vehicle = {}

---@class Plane: Vehicle
local Plane = {}
```

```lua
---@class (exact) Point
---@field x number
---@field y number
local Point = {}
Point.x = 1 -- OK
Point.y = 2 -- OK
Point.z = 3 -- Warning
```

```lua
---@class table<K, V>: { [K]: V }
```

## `@depreacted`

将函数标记为已弃用。

这将触发 `deprecated` 诊断，并将其显示为划掉。

```lua
---@deprecated
function outdated() end
```

## `@diagnostic`

切换下一行、当前行或整个文件的诊断。

```
--- @diagnostic <table>:<diagnostic>[, diagnostic...]
```

`state`选项：

- `disable-next-line`（在下一行禁用诊断）
- `disable-line`（禁用此线路上的诊断）
- `disable`（在此文件中禁用诊断）
- `enable`（在此文件中启用诊断）

```lua
---@diagnostic disable-next-line: unused-local
```

```lua
---@diagnostic enable:spell-check
```

## `@enum`

将 Lua 表标记为枚举，使其具有与 `@alias` 类似的功能，但该表在运行时仍然可用。添加(key)属性将使用枚举的键而不是其值。

```lua
--- @enum [(key)] <name>
```

```lua
---@enum colors
local COLORS = {
	black = 0,
	red = 2,
	green = 4,
	yellow = 8,
	blue = 16,
	white = 32
}

---@param color colors
local function setColor(color) end

setColor(COLORS.green)
```

```lua
---@enum (key) Direction
local direction = {
    LEFT = 1,
    RIGHT = 2,
}

---@param dir Direction
local function move(dir)
    assert(dir == "LEFT" or dir == "RIGHT")

    assert(direction[dir] == 1 or direction[dir] == 2)
    assert(direction[dir] == direction.LEFT or direction[dir] == direction.RIGHT)
end

move("LEFT")
```

## `@field`

定义表中的字段。

应紧跟在 `@class` 之后。

从 开始v3.6，您可以将字段标记为private、protected、public或package。

```
---@field [scope] <name[?]> <type> [description]
```

```
---@field [scope] [<type>] <type> [description]
```

```lua
---@class Person
---@field height number The height of this person in cm
---@field weight number The weight of this person in kg
---@field firstName string The first name of this person
---@field lastName? string The last name of this person
---@field age integer The age of this person

---@param person Person
local function hire(person) end
```

```lua
---@class Animal
---@field private legs integer
---@field eyes integer

---@class Dog:Animal
local myDog = {}

---Child class Dog CANNOT use private field legs
function myDog:legCount()
	return self.legs
end
```

```lua
---@class Animal
---@field protected legs integer
---@field eyes integer

---@class Dog:Animal
local myDog = {}

---Child class Dog can use protected field legs
function myDog:legCount()
	return self.legs
end
```

```lua
---@class Numbers
---@field named string
---@field [string] integer
local Numbers = {}
```

## `@generic`

泛型允许代码复用，并充当类型的“占位符”。

用反引号 ( \`) 括住泛型将捕获其值并将其用于该类型。

泛型目前仍处于开发阶段 。

```
---@generic <name> [:parent_type] [, <name> [:parent_type]]
```

```lua
---@generic T : integer
---@param p1 T
---@return T, T[]
function Generic(p1) end

-- v1: string
-- v2: string[]
local v1, v2 = Generic("String")

-- v3: integer
-- v4: integer[]
local v3, v4 = Generic(10)
```

```lua
---@class Vehicle
local Vehicle = {}
function Vehicle:drive() end

---@generic T
---@param class `T` # the type is captured using `T`
---@return T       # generic type is returned
local function new(class) end

-- obj: Vehicle
local obj = new("Vehicle")
```

```lua
---@class Array<T>: { [integer]: T }

---@type Array<string>
local arr = {}

-- Warns that I am assigning a boolean to a string
arr[1] = false

arr[3] = "Correct"
```

```lua
---@class Dictionary<T>: { [string]: T }

---@type Dictionary<boolean>
local dict = {}

-- no warning despite assigning a string
dict["foo"] = "bar?"

dict["correct"] = true
```

## `@meta`

将文件标记为“meta”，表示该文件用于定义，而非其 Lua 函数式代码。

语言服务器内部使用它来定义内置 Lua库 。

如果您正在编写自己的定义文件，则可能需要在其中包含此注解。

如果您指定了名称，则只有指定名称的文件才能被 require。

指定名称将使其无法被 require。

包含此标签的文件的行为略有不同

- 完成不会在元文件中显示上下文
- 将鼠标悬停require在元文件`[meta]`上将显示其绝对路径
- Find Reference忽略元文件

```lua
---@meta [name]
```

```lua
---@meta [name]
```

## `@module`

模拟 `require file`

```lua
---@module '<module_name>'
```

```lua
---@module 'http'

--The above provides the same as
require 'http'
--within the language server
```

```lua
---@module 'http'
local http

--The above provides the same as
local http = require 'http'
--within the language server
```

## `@nodiscard`

将函数标记为具有不可忽略/丢弃的返回值。

这可以帮助用户理解如何使用该函数，因为如果他们没有捕获返回值，则会引发警告。

```lua
--- @nodiscard
```

```lua
---@return string username
---@nodiscard
function getUsername() end
```

## `@operator`

```lua
---@operator <operation>[(param_type)]:<return_type>
```

此语法与定义函数的语法略有不同fun()。

请注意，这里的括号是可选的，因此@operator call:integer是有效的。

```lua
---@class Vector
---@operator add(Vector): Vector

---@type Vector
local v1
---@type Vector
local v2

--> v3: Vector
local v3 = v1 + v2
```

```lua
---@class Passcode
---@operator unm:integer

---@type Passcode
local pA

local pB = -pA
--> integer
```

建议改用@overload来指定类的调用签名。

```lua
---@class URL
---@operator call:string
local URL = {}
```

## `@overload`

为函数定义附加签名

```lua
---@overload fun([param: type[, param: type...]]): [return_value[,return_value]]
```

```lua
---@param objectID integer The id of the object to remove
---@param whenOutOfView boolean Only remove the object when it is not visible
---@return boolean success If the object was successfully removed
---@overload fun(objectID: integer): boolean
local function removeObject(objectID, whenOutOfView) end
```

```lua
---@overload fun(a: string): boolean
local foo = setmetatable({}, {
	__call = function(a)
		print(a)
        return true
	end,
})

local bool = foo("myString")
```

## `@package`

将函数标记为其定义文件的私有函数。打包的函数不能从其他文件访问。

```lua
---@package
```

```lua
---@class Animal
---@field private eyes integer
local Animal = {}

---@package
---This cannot be accessed in another file
function Animal:eyesCount()
    return self.eyes
end
```

## `@param`

为函数定义一个参数/实参。这会告诉语言服务器期望的类型，并有助于强制类型执行和提供补全功能。?在参数名称后添加问号 ( ) 表示该参数为可选类型，即可nil接受的类型。provided也type可以是@alias、@enum或@class。

```lua
---@param <name[?]> <type[|type...]> [description]
```

```lua
---@param username string The name to set for this user
function setUsername(username) end
```

```lua
---@param setting string The name of the setting
---@param value string|number|boolean The value of the setting
local function settings.set(setting, value) end
```

```lua
---@param role string The name of the role
---@param isActive? boolean If the role is currently active
---@return Role
function Role.new(role, isActive) end
```

```lua
---@param index integer
---@param ... string Tags to add to this entry
local function addTags(index, ...) end
```

```lua
---@class Box

---@generic T
---@param objectID integer The ID of the object to set the type of
---@param type `T` The type of object to set
---@return `T` object The object as a Lua object
local function setObjectType(objectID, type) end

--> boxObject: Box
local boxObject = setObjectType(1, "Box")
```

```lua
---@param mode string
---|"'immediate'"  # comment 1
---|"'async'" # comment 2
function bar(mode) end
```

```lua
local A = 0
local B = 1

---@param active integer
---| `A` # Has a value of 0
---| `B` # Has a value of 1
function set(active) end
```

## `@private`

将函数标记为私有函数@class。

私有函数只能在其所属类内访问，无法在子类中访问。

```lua
---@private
```

```lua
---@class Animal
---@field private eyes integer
local Animal = {}

---@private
function Animal:eyesCount()
    return self.eyes
end

---@class Dog:Animal
local myDog = {}

---NOT PERMITTED!
myDog:eyesCount();
```

## `@protected`

将函数标记为受保护@class。受保护的函数只能在其类或子类中访问。

```lua
---@protected
```

```lua
---@class Animal
---@field private eyes integer
local Animal = {}

---@protected
function Animal:eyesCount()
    return self.eyes
end

---@class Dog:Animal
local myDog = {}

---Permitted because function is protected, not private.
myDog:eyesCount();
```

## `@return`

```lua
---@return <type> [<name> [comment] | [name] #<comment>]
```

```lua
---@return boolean
local function isEnabled() end
```

```lua
---@return boolean enabled
local function isEnabled() end
```

```lua
---@return boolean enabled If the item is enabled
local function isEnabled() end
```

```lua
---@return boolean # If the item is enabled
local function isEnabled() end
```

```lua
---@return boolean|nil error
local function makeRequest() end
```

```lua
---@return integer count Number of nicknames found
---@return string ...
local function getNicknames() end
```

## `@see`

允许您从工作区引用特定符号（例如function） 。您也可以使用Markdown 链接引用符号。class

```lua
---@see <symbol>
```

```lua
---Hovering the below function will show a link that jumps to http.get()

---@see http.get
function request(url) end
```

## `@source`

提供对位于其他文件中的源代码的引用。搜索某个项目的定义时，@source将使用其定义。

```lua
---@source <path>
```

```lua
---@source C:/Users/me/Documents/program/myFile.c
local a
```

```lua
---@source file:///C:/Users/me/Documents/program/myFile.c:10
local b
```

```lua
---@source local/file.c
local c
```

```lua
---@source local/file.c:10:8
local d
```

## `@type`

将变量标记为特定类型。联合类型用竖线字符 分隔|。type提供的可以是@alias、@enum或@class。请注意，您不能使用 向类添加字段@type，而必须使用 。 @class

```lua
---@type <type>
```

```lua
---@type boolean
local x
```

```lua
---@type string[]
local names
```

```lua
---@type { [string]: boolean }
local statuses
```

```lua
---@type table<userID, Player>
local players
```

```lua
---@type boolean|number|"yes"|"no"
local x
```

```lua
---@type fun(name: string, value: any): boolean
local x
```

## `@version`

标记所需的 Lua 版本function或@class。

```lua
---@version [<|>]<version> [, [<|>]version...]
```

可能的version值：

- 5.1
- 5.2
- 5.3
- 5.4
- JIT

```lua
---@version >5.2, JIT
function hello() end
```

```lua
---@version 5.4
---@class Entry
```
