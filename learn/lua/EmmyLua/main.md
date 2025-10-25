# Emmylua

## `@class`

```
---@class MY_TYPE[:PARENT_TYPE] [@comment]
```

```lua
--- @class Car: Transport @define class Car extends Transport
local cls = class()

function cls:test() 
end
```

指定变量cls是类Car，因此我们可以使用它@type来指定其他变量的类型为 Car，这可以提高完成度和其他功能

## `@type`

```
---@type MY_TYPE[|OTHER_TYPE] [@comment]
```

1. 局部变量

```lua
---@type Car @instance of car
local car1 = {}

---@type Car|Ship @transport tools, car or ship.....
--- use | to list all possible types
local transport = {}
```

2. 全局变量

```lua
---@type Car @global variable type
global_car = {}
```

3.特性

```lua
local obj = {}
---@type Car @property type
obj.car = getCar()
```

## `@alias`

```
---@alias NEW_NAME TYPE
```

```lua
---@alias Handler fun(type: string, data: any):void

---@param hanlder Handler
function addHandler(handler)
end
```

## `@param`

```
---@param param_name MY_TYPE[|other_type] [@comment]
```

1. 函数参数

```lua
---@param car Car
local function setCar(car)
end
```

```lua
---@param car Car
setCallback(function(car)
end)
```

2. `for`循环

```lua
---@param car Car
for k, car in ipairs(list) do
end
```

## `@return`

```
---@return MY_TYPE[|OTHER_TYPE] [@comment]
```

1. 函数

```lua
--- @return Car|Ship
local function create()
end
```

```lua
---@return Car
function factory:create()
end
```

## `@field`

```
---@field [public|protected|private] field_name FIELD_TYPE[|OTHER_TYPE] [@comment]
```

```lua
---@class Car
---@field public name string @add name field to class Car, you'll see it in code completion
local cls = class()
```
