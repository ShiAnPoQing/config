--[[

'statusline'

%-0{minwid}.{maxwid}{item}

1. [-]        左对齐，默认情况下，当 minwid 大于项目长度时，项目右对齐
2. [0]        数字项目中的前导0。被 “-” 覆盖
3. [minwid]   项目最小宽度，按 "-" 和 "0" 设置填充。值必须 <= 50。
4. [maxwid]   项目的最大宽度。
                对于文本项目，截断时会在左侧出现 "<"。
                数字项目将缩减为 maxwid-2 位数字，后跟 ">"number，
                其中 number 是缺失的数字数，类似于 指数表示法。
5. item       项目内容。

[-]       Example: 左对齐： "%#StatusLine#%-5l%#Normal#"
[0]       Example: 前导0：  %05l" -> "00001" 
[minwid]  Example: 略
[maxwid]  Example: 数字项目 %.3l "123"  -> "123"
                                 "1234" -> "1>3"
                   文本项目 %.4t "init.lua" -> ">lua"



{String item}
  f 缓冲区中文件的路径，按键入或相对于当前目录
  F 缓冲区中文件的完整路径 
  t 缓冲区中文件的文件名(尾部)
  q "[Quickfix List]"，"[Location List]" 或空。
  k 当使用 |:lmap| 映射时，"b:keymap_name" 或 'keymap' 的值："<keymap>"
  P 显示窗口在文件中的百分比。
      这类似于 'ruler' 中描述的百分比。长度总是 3， 除非被翻译。

  S 'showcmd' 的内容
  a 参数列表状态，如默认标题中所示。（{当前} 共 {最大}）
       如果参数文件计数为零或一，则为空。


{Number item} 
  n 缓冲区编号
  b 光标下字符的值
  B 同上，但在十六进制显示 
  o 光标下字节在文件中的字节数，第一个字节为 1。助记：从文件开头的偏移量（加一）
  O 同上，但在十六进制显示 
  l 行号
  L 缓冲区中的行数
  c 列号（字节索引）
  v 虚拟列号（屏幕列）
  V 虚拟列号，显示为 -{num}。如果等于 'c' 则不显示。
  p 文件中行数的百分比

  T 对于 'tabline'：标签页 N 标签的开始。使用 %T 或 %X 结束标签。
    用鼠标左键单击此标签 切换到指定的标签页，用鼠标中键单击则关闭指定的标签页。
    eg: 
      %1T tab1 %T %2T tab2 %T %999T current tab %T %3T tab3 %T  
  X 对于 'tabline'：关闭标签 N 标签的开始。使用 %X 或 %T 结束标签，
    例如：%3Xclose%X。
      使用 %999X 作为 "关闭当前标签" 标签。
      用鼠标左键单击此标签关闭指定的标签页。
  @ 执行函数标签的开始。使用 %X 或 %T 结束标签，
      例如：%10@SwitchBuffer@foo.c%X。
        单击此标签会运行指定的函数：
        在示例中，当用鼠标左键单击 "foo.c" 一次时，
        将运行 `SwitchBuffer(10, 1, 'l', '    ')` 表达式。
        指定的函数按顺序接收以下参数：
          1. minwid 字段值，如果未指定 N 则为零
          2. 鼠标单击次数，用于检测多次单击
          3. 使用的鼠标按钮："l"、"r" 或 "m"，分别表示左键、右键或中键；不应依赖第三个
             参数仅为 "l"、"r" 或 "m"：其他鼠标按钮可能会提供仅包含 ASCII 小写字母的
             任何其他非空字符串值
          4. 按下的修饰键：字符串，如果按下了 shift 修饰键则包含 "s"，control 为 "c"，
             alt 为 "a"，meta 为 "m"；如果未按下修饰键，当前字符串包含空格，但不应依赖
             空格的存在或修饰键的特定顺序：使用 |stridx()| 测试是否存在某个修饰键；
             保证字符串仅包含 ASCII 字母和空格，每个修饰键一个字母；"?" 修饰键也可能存在，
             但其存在是一个错误，表示添加了新的鼠标按钮识别，但未修改对此标签上鼠标单击
             做出反应的代码。

{Flag item}
  m 修改该标志 "[+]" 或 "[-]" 标记。 
  M 修改该标志 ",+" 或 ",-" 标记。 
  r 只读标志 "[RO]"
  R 只读标志 ",RO" 
  h 帮助缓冲区标志 "[help]" 
  H 帮助缓冲区标志 ",HLP" 
  w 预览窗口标志 "[Preview]" 
  W 预览窗口标志 ",PRV" 
  y 缓冲区文件的类型 "[vim]"
  Y 缓冲区文件的类型 ",VIM" 

{Other item}
  {  NF 评估 "%{" 和 "}" 之间的表达式并替换结果。
       注意，结束的 "}" 前没有 "%"。
       表达式不能包含 "}" 字符，可以通过调用函数来解决。
       参见下面的 |stl-%{|。
       %{ "}" }   → ❌ 错误
       %{ MyFunc() } → ✅ 可以

  {%  这与 "{" 几乎相同，只是表达式的结果会被重新评估为状态行格式字符串。
       因此，如果表达式的返回值包含 "%" 项，它们将被展开。
       表达式可以包含 "}" 字符，表达式结束由 "%}" 表示。
       例如：
          func! Stl_filename() abort
              return "%t"
          endfunc
<         stl=%{Stl_filename()}   结果在 `"%t"`
          stl=%{%Stl_filename()%} 结果在 `"当前文件的名称"`

   %} "{%" 表达式的结束

   ( 项目组的开始。可用于设置部分的宽度和对齐方式。
      后面必须跟有 %) 某处。
      eg: %-14.(%t%m%r%)
   ) 项目组的结束。不允许有宽度字段。

  <  如果行太长，在此处截断。默认在开头截断。不允许有宽度字段。
  =  对齐部分之间的分隔点。
      每个部分将由相等数量的空格分隔。
      使用一个 %= 时，其后的内容将右对齐。
      使用两个 %= 时，中间有一个部分，其左右两边有空白。
      不允许有宽度字段。

      如果 %= 出现1 次
        左边的内容 → 左对齐
        右边的内容 → 右对齐
      如果 %= 出现2 次
        左边的内容 → 左对齐
        中间部分   → 居中显示
        右边的内容 → 右对齐

  #  设置高亮组。名称必须紧跟其后，然后再跟一个 #。
     因此使用 %#HLname# 表示高亮组 HLname。
     使用相同的高亮显示，也用于非当前窗口的状态行。
  $  与 `#` 相同，除了 `%$HLname$` 组将从先前的高亮属性继承。
  *  将高亮组设置为 User{N}，其中 {N} 取自 minwid 字段，
     例如 %1*。使用 %* 或 %0* 恢复正常高亮。
     User{N} 和 StatusLine 之间的差异将应用于非当前窗口状态行的 StatusLineNC。
     数字 N 必须在 1 到 9 之间。参见 |hl-User1..9|


显示标志时，如果该标志紧跟在纯文本之后，Vim 会移除前导逗号（如果有）。
 set statusline=%t,%m,%r

当一个组中的所有项目都变成空字符串（即未设置的标志）且没有为组设置 minwid 时，
整个组将变为空。这将使像下面这样的组在没有任何标志设置时完全从状态行中消失。
 set statusline=...%(\ [%M%R%H]%)...

在评估 %{} 时，当前缓冲区和当前窗口将临时设置为正在绘制状态行的窗口（和缓冲区）。
  表达式将在该上下文中评估。变量 "g:actual_curbuf" 设置为真实当前缓冲区的 `bufnr()`
  编号，"g:actual_curwin" 设置为真实当前窗口的 |window-ID|。这些值是字符串。

情况  结果
modeline 里设置 statusline 表达式 如果 modelineexpr=off → 不生效
modeline 里设置普通选项 正常生效
modeline 里设置 statusline 表达式且 modelineexpr=on 生效，但在 sandbox 限制下

  vim.opt.statusline = "%#StatusLine#%m%#Normal#"
  vim.opt.statusline = "%<%f %h%w%m%r%=%-14.(%l,%c%V%) %P"
  vim.opt.statusline = "%<%f%h%m%r%=%b 0x%B  %l,%c%V %P"
  vim.opt.statusline = "%<%f%= [%1*%M%*%n%R%H] %-19(%3l,%02c%03V%)%O'%02b'"

--]]

local M = {}

--- @class PlainStatusline.Component.EventConfig
--- @field pattern? string|string[]
--- @field callback? string|fun(self: PlainStatusline.Component, args: vim.api.keyset.create_autocmd.callback_args): boolean?

--- @class PlainStatusline.Component.Events: PlainStatusline.Component.EventConfig
--- @field [integer] PlainStatusline.Component.Event

--- @alias PlainStatusline.Component.Event string|PlainStatusline.Component.Events

--- @class PlainStatusline.Component
--- @field condition? fun(self: PlainStatusline.Component): any
--- @field init? fun(self: PlainStatusline.Component)
--- @field update? fun(self: PlainStatusline.Component)
--- @field event? PlainStatusline.Component.Event
--- @field provider? string|number|fun(self: PlainStatusline.Component):string|number
--- @field hl? string|vim.api.keyset.highlight|fun(self: PlainStatusline.Component):string|vim.api.keyset.highlight

--- @type PlainStatusline._Component
local Root

--- @param opts PlainStatusline.Component
function M.setup(opts)
  opts = vim.tbl_deep_extend("force", {}, opts or {})
  Root = require("plain-statusline.component"):new(opts)
  vim.opt.statusline = "%{%v:lua.require'plain-statusline'.statusline()%}"
end

function M.statusline()
  return Root:eval()
end

function M.get_mode()
  local mode = vim.api.nvim_get_mode().mode
  local m = {
    n = "NORMAL",
    i = "INSERT",
    v = "VISUAL",
    V = "V-LINE",
    ["\22"] = "V-BLOCK", -- Ctrl+V
    R = "REPLACE",
    c = "COMMAND",
    s = "SELECT",
    S = "S-LINE",
    ["\19"] = "S-BLOCK",
    t = "TERMINAL",
  }
  return m[mode] or mode
end

return M
