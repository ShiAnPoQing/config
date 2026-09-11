local M = {}

--- @class Luma.Config

--- @param colors table<string,string>
--- @return table<string, vim.api.keyset.highlight>
local function get_groups(colors)
  local syntax = {
    Normal = { bg = colors.dark7, fg = colors.dark76 },
    Comment = { fg = colors.dark25 },
    String = { fg = colors.hue15 },
    Boolean = { fg = colors.hue72 },
    Number = { fg = colors.hue72 },
    CursorLine = { bg = colors.dark15 },
    Visual = { bg = colors.dark20 },
    Special = { fg = colors.hue72 },
    Folded = { bg = colors.dark15 }
  }
  local treesitter = {
    -- @keyword                不属于特定类别的关键字
    ["@keyword"] = { fg = colors.dark35 },
    -- @keyword.coroutine      与协程相关的关键字（例如 Go 中的 `go`，Python 中的 `async/await`）
    -- @keyword.function       定义函数的关键字（例如 Go 中的 `func`，Python 中的 `def`）
    -- @keyword.operator       作为英文单词的运算符（例如 `and`、`or`）
    -- @keyword.import         用于包含或导出模块的关键字（例如 Python 中的 `import`、`from`）
    -- @keyword.type           描述命名空间和复合类型的关键字（例如 `struct`、`enum`）
    -- @keyword.modifier       修改其他结构的关键字（例如 `const`、`static`、`public`）
    -- @keyword.repeat         与循环相关的关键字（例如 `for`、`while`）
    -- @keyword.return         像 `return` 和 `yield` 这样的关键字
    -- @keyword.debug          与调试相关的关键字
    -- @keyword.exception      与异常相关的关键字（例如 `throw`、`catch`）
    -- @keyword.conditional         与条件语句相关的关键字（例如 `if`、`else`）
    -- @keyword.conditional.ternary 三元运算符（例如 `?`、`:`）
    -- @keyword.directive           各种预处理器指令和 shebang
    -- @keyword.directive.define    预处理器定义指令

    -- @variable                       各种变量名
    ["@variable"] = { fg = colors.dark60 },
    -- @variable.builtin                内置变量名（例如 `this`、`self`）
    -- @variable.parameter              函数的参数
    -- @variable.parameter.builtin      特殊参数（例如 `_`、`it`）
    -- @variable.member                 对象和结构体字段

    -- @function               函数定义
    ["@function"] = { fg = colors.dark70 },
    -- @function.builtin       内置函数
    ["@function.builtin"] = { link = "@function" },
    -- @function.call          函数调用
    -- @function.macro         预处理器宏
    -- @function.method        方法定义
    -- @function.method.call   方法调用

    -- @string                 字符串字面量
    ["@string"] = { link = "String" },
    -- @string.documentation   记录代码的字符串（例如 Python 文档字符串）
    -- @string.regexp          正则表达式
    -- @string.escape          转义序列
    ["@string.escape"] = { link = "Special" },
    -- @string.special         其他特殊字符串（例如日期）
    -- @string.special.symbol  符号或原子
    -- @string.special.path    文件名
    -- @string.special.url     URI（例如超链接）

    -- @constructor            构造函数调用和定义
    ["@constructor"] = { link = "@keyword" },
    -- @operator               符号运算符（例如 `+`、`*`）
    ["@operator"] = { link = "@keyword" },

    -- @comment                行注释和块注释
    ["@comment"] = { link = "Comment" },
    -- @comment.documentation  记录代码的注释
    -- @comment.error          错误类型注释（例如 `ERROR`、`FIXME`、`DEPRECATED`）
    -- @comment.warning        警告类型注释（例如 `WARNING`、`FIX`、`HACK`）
    -- @comment.todo           todo 类型注释（例如 `TODO`、`WIP`）
    -- @comment.note           备注类型注释（例如 `NOTE`、`INFO`、`XXX`）

    -- @markup.strong          粗体文本
    -- @markup.italic          斜体文本
    -- @markup.strikethrough   删除线文本
    -- @markup.underline       下划线文本（仅用于字面下划线标记！）
    -- @markup.heading         标题（包括标记）
    -- @markup.heading.1       顶级标题
    -- @markup.heading.2       章节标题
    -- @markup.heading.3       子章节标题
    -- @markup.heading.4       依此类推
    -- @markup.heading.5       等等
    -- @markup.heading.6       六级标题对任何人来说都应该足够了
    --
    -- @markup.quote           块引用
    -- @markup.math            数学环境（例如 LaTeX 中的 `$ ... $`）
    --
    -- @markup.link            文本引用、脚注、引文等
    -- @markup.link.label      链接、引用描述
    -- @markup.link.url        URL 风格的链接
    --
    -- @markup.raw             字面量或原样文本（例如内联代码）
    -- @markup.raw.block       作为独立块的字面量或原样文本
    --
    -- @markup.list            列表标记
    -- @markup.list.checked    已勾选的待办事项列表标记
    -- @markup.list.unchecked  未勾选的待办事项列表标记

    -- @diff.plus              添加的文本（用于 diff 文件）
    -- @diff.minus             删除的文本（用于 diff 文件）
    -- @diff.delta             更改的文本（用于 diff 文件）

    -- @tag                    XML 风格的标签名（例如在 XML、HTML 等中）
    -- @tag.builtin            内置标签名（例如 HTML5 标签）
    -- @tag.attribute          XML 风格的标签属性
    -- @tag.delimiter          XML 风格的标签分隔符

    -- @type                   类型或类定义及注解
    -- @type.builtin           内置类型
    -- @type.definition        类型定义中的标识符（例如 C 中的 `typedef <type> <identifier>`）

    -- @attribute              属性注解（例如 Python 装饰器、Rust 生命周期）
    -- @attribute.builtin      内置注解（例如 Python 中的 `@property`）
    -- @property               键值对中的键
    ["@property"] = { fg = colors.hue45 },

    -- @boolean                布尔字面量
    -- @number                 数字字面量
    -- @number.float           浮点数数字字面量

    -- @character              字符字面量
    -- @character.special      特殊字符（例如通配符）

    -- @constant               常量标识符
    ["@constant"] = { link = "Boolean" },
    -- @constant.builtin       内置常量值
    ["@constant.builtin"] = { link = "@constant" },
    -- @constant.macro         由预处理器定义的常量

    -- @module                 模块或命名空间
    -- @module.builtin         内置模块或命名空间
    -- @label                   `GOTO` 和其他标签（例如 C 中的 `label:`），包括 heredoc 标签

    -- @character              字符字面量
    -- @character.special      特殊字符（例如通配符）

    -- @punctuation.delimiter  分隔符（例如 `;`、`.`、`,`）
    ["@punctuation.delimiter"] = { link = "@keyword" },
    -- @punctuation.bracket    括号（例如 `()`、`{}`、`[]`）
    ["@punctuation.bracket"] = { link = "@keyword" },
    -- @punctuation.special    特殊符号（例如字符串插值中的 `{}`）
  }
  local lsp = {
    ["@lsp.type.property"] = { link = "@lsp.type.property" },
  }
  return vim.tbl_deep_extend("force", syntax, treesitter, lsp)
end

--- @param config? Luma.Config
function M.setup(config)
  config = config or {}
end

function M.loader()
  if vim.g.colors_name then
    vim.cmd("hi clear")
  end
  vim.o.termguicolors = true
  vim.g.colors_name = "luma"
  local colors = require("luma.colors").load()
  for group, hl in pairs(get_groups(colors)) do
    vim.api.nvim_set_hl(0, group, hl)
  end
end

return M
