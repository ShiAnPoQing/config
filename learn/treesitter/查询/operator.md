# 运算符

## 捕获节点

> 匹配模式时，您可能需要处理模式中的特定节点。

捕获允许您将名称与模式中的特定节点关联，以便稍后可以通过这些名称引用这些节点。捕获名称写在 它们引用的节点之后@，并以字符开头。

例如，此模式将匹配 afunction到 an的任何分配identifier，并将名称 the-function-name与标识符关联：

```query
(assignment_expression
  left: (identifier) @the-function-name
  right: (function))
```

此模式将匹配所有方法定义，将名称the-method-name与方法名称the-class-name 以及包含的类名关联起来：

```query
(class_declaration
  name: (identifier) @the-class-name
  body: (class_body
    (method_definition
      name: (property_identifier) @the-method-name)))
```

## 量化运算符

> 您可以使用后缀 + 和 * 重复运算符来匹配重复的同级节点序列，其工作原理类似于正则表达式中的 + 和 * 运算符。

- 运算符匹配模式的一个或多个重复，而 * 运算符匹配零个或多个重复。

例如，此模式将匹配一个或多个注释的序列：

```query
(comment)+
```

此模式将匹配类声明，捕获所有存在的装饰器：

```query
(class_declaration
  (decorator)* @the-decorator
  name: (identifier) @the-name)
```

你也可以使用 ? 运算符将节点标记为可选。

例如，此模式将匹配所有函数调用，并捕获字符串参数（如果存在）：

```query
(call_expression
  function: (identifier) @the-function
  arguments: (arguments (string)? @the-string-arg))
```

## 分组兄弟节点

> 你也可以使用括号对一系列兄弟节点进行分组。

例如，以下模式将匹配注释后跟函数声明：

```query
(
  (comment)
  (function_declaration)
)
```

上述任何量化运算符（+、\*和?）也可以应用于组。例如，此模式将匹配以逗号分隔的一系列数字：

```query
(
  (number)
  ("," (number))*
)
```

## 交替

> 替换写成一对方括号 ([])，其中包含替换模式列表。这类似于正则表达式中的字符类（[abc] 匹配 a、b 或 c）。

例如，此模式将匹配对变量或对象属性的调用。

对于变量，将其捕获为 @function；
对于属性，将其捕获为 @method：

```query
(call_expression
  function: [
    (identifier) @function
    (member_expression
      property: (property_identifier) @method)
  ])
```

此模式将匹配一组可能的关键字标记，并将它们捕获为@keyword：

```query
[
  "break"
  "delete"
  "else"
  "for"
  "function"
  "if"
  "return"
  "try"
  "while"
] @keyword
```

## 锚点

> 锚点运算符 . 用于限制子模式的匹配方式。

它的行为取决于它在查询中的位置。

当 . 位于父模式中第一个子模式之前时，只有当子模式是父模式中的第一个命名节点时，它才会匹配。

例如，以下模式最多匹配给定数组节点一次，并将 @the-element 捕获赋值给父数组中的第一个标识符节点：

```query
(array . (identifier) @the-element)
```

如果没有此锚点，该模式将对数组中的每个标识符匹配一次，并将 @the-element 绑定到每个匹配的标识符。

同样，如果将锚点放置在模式的最后一个子节点之后，则该子模式将仅匹配其父节点的最后一个命名子节点。以下模式仅匹配块中最后一个命名子节点。

```query
(block (_) @last-expression .)
```

最后，两个子模式之间的锚点将导致模式仅匹配其直系兄弟节点。下面的模式，给定一个像 a.b.c.d 这样的长点号，将仅匹配连续的标识符对：a、b、b、c 和 c、d。

```query
(dotted_name
  (identifier) @prev-id
  .
  (identifier) @next-id)
```

如果没有锚点，像 a、c 和 b、d 这样的非连续对也会被匹配。

锚点运算符对模式的限制会忽略匿名节点。
