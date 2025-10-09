# Query

> 查询由一个或多个模式组成，每个模式都是一个S 表达式，用于匹配语法树中的一组特定节点。

用于匹配给定节点的表达式由一对括号组成，括号包含两个内容：节点的类型，以及可选的一系列用于匹配该节点子节点的其他 S 表达式。

```query
(binary_expression (number_literal) (number_literal))
```

例如，以下代码将匹配 `binary_expression` 至少有一个子节点为 `string_literal` 节点的任意子节点：

```query
(binary_expression (string_literal))
```

## 字段

> 一般来说，通过指定与子节点关联的字段名称来使模式更具体是一个好主意。你可以在子模式前加上字段名称，后跟冒号。

```query
(assignment_expression
  left: (member_expression
    object: (call_expression)))
```

## 否定字段

> 您还可以限制模式，使其仅匹配缺少特定字段的节点。
> 为此，请在父模式中添加以 ! 为前缀的字段名称。

例如，此模式将匹配没有类型参数的类声明：

```query
(class_declaration
  name: (identifier) @class_name
  !type_parameters)
```

## 匿名节点

> 括号内用于书写节点的语法仅适用于命名节点。
> 要匹配特定的匿名节点，请将其名称放在双引号中。

例如，此模式将匹配任何运算符为 `!=` 且右侧为空的 `binary_expression`：

```query
(binary_expression
  operator: "!="
  right: (null))
```

## 特殊节点

> 通配符节点用下划线 (\_) 表示，它匹配任何节点。
> 这类似于正则表达式中的 . 。

通配符节点有两种类型：
`(_)` 匹配任何命名节点，
而 `_` 匹配任何命名或匿名节点。

```query
(call (_) @call.inner)
```

## Error节点

当解析器遇到无法识别的文本时，它会像(ERROR)在语法树中一样表示此节点。这些错误节点可以像普通节点一样进行查询：

```query
(ERROR) @error-node
```

## Missing节点

> 如果解析器能够通过插入缺失的标记并进行归约来恢复错误的文本，那么只要最终的树具有最低的错误成本，它就会将该缺失的节点插入到最终的树中。
> 这些缺失的节点在树中看起来像是正常的节点，但它们的宽度为零，并且在内部表示为实际插入的终端节点的属性，而不是像ERROR节点那样属于自己的节点类型。
> 这些特殊的缺失节点可以使用以下方式查询(MISSING)：

```query
(MISSING) @missing-node
```

这在尝试检测给定解析树中的所有语法错误时非常有用，因为(ERROR)查询无法捕获这些缺失的节点。还可以查询特定的缺失节点类型：

```query
(MISSING identifier) @missing-identifier
(MISSING ";") @missing-semicolon
```

## 超类型节点

> 某些节点类型在语法中被标记为超类型。
> 超类型是包含多个子类型的节点类型。
> 例如，在JavaScript 语法示例中，expression是一个可以表示任何类型表达式的超类型，例如binary_expression、call_expression或identifier。您可以在查询中使用超类型来匹配其任何子类型，而不必逐一列出每个子类型。例如，此模式将匹配任何类型的表达式，即使它不是语法树中的可见节点：

```query
(expression) @any-expression
```

要查询父类型的特定子类型，可以使用语法supertype/subtype。例如，此模式binary_expression仅当 a 是 的子类型时才会匹配expression：

```query
(expression/binary_expression) @binary-expression
```

这也适用于匿名节点。例如，此模式"()"仅当它是 的子节点时才匹配expression：

```query
(expression/"()") @empty-expression
```
