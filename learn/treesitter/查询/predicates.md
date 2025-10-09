# 谓词

您还可以通过在模式中的任意位置添加谓词 S 表达式来指定与模式关联的任意元数据和条件。

谓词 S 表达式以谓词名称开头，该谓词名称以 # 字符开头，以 ? 字符结尾。之后，它们可以包含任意数量的以 @ 为前缀的捕获名称或字符串。

Tree-sitter 的 CLI 默认支持以下谓词：

## 谓词eq?

该谓词系列允许您匹配单个捕获或字符串值。

此谓词的第一个参数必须是一个捕获，但第二个参数可以是用于比较两个捕获文本的捕获，也可以是用于与第一个捕获文本进行比较的字符串。

基本谓词是#eq?，但其补语#not-eq?可用于不 匹配值。此外，您可以在其中任何一个节点前添加 ，以便在任何any-节点与谓词匹配时进行匹配。这仅在处理量化捕获时有用，因为默认情况下，量化捕获仅当所有捕获的节点都与谓词匹配时才会匹配。

因此，总共有四个谓词：

- `#eq?`
- `#not-eq?`
- `#any-eq?`
- `#any-not-eq?`

```query
((identifier) @variable.builtin
  (#eq? @variable.builtin "self"))
```

此模式将匹配任何标识符self。

```query
(
  (pair
    key: (property_identifier) @key-name
    value: (identifier) @value-name)
  (#eq? @key-name @value-name)
)
```

如前所述，any-前缀用于量化捕获。以下是在一组注释中查找空注释的示例：

```query
((comment)+ @comment.empty
  (#any-eq? @comment.empty "//"))
```

## 谓词match?

这些谓词与谓词eq?类似，但它们使用正则表达式来匹配捕获的文本而不是字符串比较。

第一个参数必须是捕获，第二个参数必须是包含正则表达式的字符串。

与谓词系列一样eq?，我们可以not-在谓词的开头添加否定匹配，并且如果量化捕获中的任何节点与谓词匹配，any-则进行匹配。

此模式与以 编写的标识符匹配SCREAMING_SNAKE_CASE。

```query
((identifier) @constant
  (#match? @constant "^[A-Z][A-Z_]+"))
```

此查询识别以三个正斜杠 ( ) 开头的 C 语言文档注释///。

```query
((comment)+ @comment.documentation
  (#match? @comment.documentation "^///\\s+.*"))
```

此查询查找嵌入在 Go 注释中的 C 代码，这些注释位于“C”导入语句之前。这些注释称为Cgo注释，用于将 C 代码注入 Go 程序。

```query
((comment)+ @injection.content
  .
  (import_declaration
    (import_spec path: (interpreted_string_literal) @_import_c))
  (#eq? @_import_c "\"C\"")
  (#match? @injection.content "^//"))
```

## 谓词any-of?

谓词any-of?允许您将捕获与多个字符串进行匹配，并且如果捕获的文本等于任何字符串，则匹配。

下面的查询将匹配 JavaScript 中的任何内置变量。

```query
((identifier) @variable.builtin
  (#any-of? @variable.builtin
        "arguments"
        "module"
        "console"
        "window"
        "document"))
```

## 谓词is?

谓词is?允许你断言一个捕获是否具有给定的属性。这并没有被广泛使用，但 CLI 使用它来判断给定节点是否是局部变量，例如：

```query
((identifier) @variable.builtin
  (#match? @variable.builtin "^(arguments|module|console|window|document)$")
  (#is-not? local))
```

#is-not? local由于使用了谓词，此模式将匹配任何非局部变量的内置变量。

# 指令

与谓词类似，指令是一种将任意元数据与模式关联起来的方法。谓词和指令之间的唯一区别在于，指令以!字符结尾，而不是以?字符结尾。

Tree-sitter 的 CLI 默认支持以下指令：

## #set!指令

此指令允许您将键值对与模式关联。键和值可以是您认为合适的任意文本。

```query
((comment) @injection.content
  (#match? @injection.content "/[*\/][!*\/]<?[^a-zA-Z]")
  (#set! injection.language "doxygen"))
```

此模式将匹配任何包含 Doxygen 样式注释的注释，然后将injection.language键设置为 "doxygen"。以编程方式，在迭代此模式的捕获时，您可以访问此属性，然后使用 Doxygen 解析器解析注释。

## #select-adjacent!指令

该#select-adjacent!指令允许你过滤与捕获相关的文本，以便仅保留与另一个捕获相邻的节点。它接受两个参数，均为捕获名称。

## #strip!指令

该#strip!指令允许你从捕获内容中删除文本。它接受两个参数：第一个参数是要从中去除文本的捕获内容，第二个参数是用于匹配文本的正则表达式。任何与正则表达式匹配的文本都将从与捕获内容关联的文本中删除。

#select-adjacent!有关和指令的示例#strip!，请查看代码导航文档。
