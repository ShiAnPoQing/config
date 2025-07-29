local M = {}

local function create_flot_win(opts)
  local width = opts.width or 50
  local height = opts.height or 10
  local row = opts.row or 1
  local col = opts.col or 1

  local win_opts = {
    relative = "editor",
    width = width,
    row = row,
    col = col,
    height = height,
    anchor = "NW",
    style = "minimal",
    border = "rounded",
  }

  if opts.title then
    win_opts.title = opts.title
  end
  if opts.title_pos then
    win_opts.title_pos = opts.title_pos
  end
  if opts.focusable ~= nil then
    win_opts.focusable = opts.focusable
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, 1, false, { "你好" })

  local win = vim.api.nvim_open_win(buf, false, win_opts)

  return buf, win
end

function M.picker()
  local width = 60
  local input_height = 1
  local list_height = 10
  local total_height = input_height + list_height + 3 -- 3为边框空间

  local win_width = vim.o.columns
  local win_height = vim.o.lines
  local col = (win_width - width) / 2
  local row = (win_height - total_height) / 2

  local list_buf, list_win = create_flot_win({
    width = width - 2,
    height = list_height,
    row = row + input_height + 2 + 1,
    col = col + 1,
    focusable = false,
  })
  local input_buf, input_win = create_flot_win({
    title = " SEARCH ",
    title_pos = "center",
    width = width - 2,
    height = input_height,
    row = row + 1,
    col = col + 1,
  })

  vim.api.nvim_buf_set_option(input_buf, "buftype", "prompt")
  vim.fn.prompt_setprompt(input_buf, "> ")

  vim.keymap.set("i", "<Esc>", function()
    vim.api.nvim_win_close(input_win, true)
    vim.api.nvim_win_close(list_win, true)
  end, { buffer = input_buf })

  -- 自动聚焦输入框
  vim.api.nvim_set_current_win(input_win)
  vim.api.nvim_feedkeys("i", "n", false)
end

return M

--[[

若指定 `relative` 参数则创建浮动窗口，
若指定 `external` 参数则创建由 GUI 管理的外部窗口。

当打开浮动窗口时，必须指定 `width` 和 `height` 参数，
但对普通分屏窗口这些参数是可选。

API: nvim_open_win(buffer: number, enter: boolean, config: WinConfig): number(window_ID) | 0): 打开一个新的分屏窗口

@params
| 参数        | 类型   | 说明                                                                 |
|------------|--------|----------------------------------------------------------------------|
| {buffer}   | number | 要显示的缓冲区，0 表示当前缓冲区                                      |
| {enter}    | boolean| 是否进入该窗口（设为当前窗口）                                        |
| {config}   | table  | 窗口配置字典，支持以下键：                                            |

@return
- 成功：窗口句柄 (window-ID)
- 失败：0

interface WinConfig {
              窗口定位基准
  relative: "editor" | "win" | "cursor" | "mouse"
    - "editor" 全局编辑器网格
    - "win"    由 `win` 字段指定的窗口，或当前窗口
    - "cursor" 当前窗口中的光标位置
    - "mouse"  鼠标位置

              浮动窗口坐标（若指定则忽略 relative 参数）
  row: number（允许小数）
  col: number（允许小数）
    - • `row=1` and `col=0` if `anchor` is "NW" or "NE"
      • `row=0` and `col=0` if `anchor` is "SW" or "SE"


              基准窗口: 要拆分的窗口/创建浮动时的相对窗口
  win: number(window_ID)

              锚点位置
  anchor: "NW"(default 西北) | "NE"（东北） | "SW"（西南） | "SE"（东南）

              窗口宽度
  width: number >=1

              窗口高度
  height: number >=1

              相对于缓冲区文本的位置
  bufpos: [line, columns] (0-based)

              是否允许聚焦(不可聚焦的窗口可以通过 nvim_set_current_win 聚焦)
  focusable: boolean（default: true）

              GUI 应将窗口显示为外部独立窗口
  external: boolean

              窗口堆叠数序（default: 50）
  zindex: number>=0
  - 100：插入完成弹出菜单
  - 200：消息回滚 •
  - 250：命令行完成弹出菜单（当 wildoptions+=pum 时）
  - 浮点数的默认值为 50。
  - 一般情况下，建议使用低于 100 的值，除非有充分理由遮盖内置元素。

              极简模式
  style?: "minimal"
        Nvim 将显示禁用许多 UI 选项的窗口。
        这在显示不应编辑文本的临时浮点数时很有用
        禁用 'number'、'relativenumber'、'cursorline'、'cursorcolumn'、'foldcolumn'、'spell' 和 'list'选项。
        'signcolumn' 更改为 `auto`，'colorcolumn' 被清除。'statuscolumn' 更改为空。
        通过将 'fillchars' 的`eob` 标志设置为空格字符并清除'winhighlight' 中的 |hl-EndOfBuffer| 区域，可以隐藏缓冲区末尾区域。

              边框样式
  border:
      | "none"
      | "single"
      | "double"
      | "rounded" like "single" but rounded
      | "solid"   通过单个空白单元格添加填充
      | "shadow"  通过与背景混合实现阴影效果
      | Array(顺时针)
                      如果字符数少于 8，则将重复这些字符
                      border = { "╔", "═" ,"╗", "║", "╝", "═", "╚", "║" }  -- 双线边框
                      border = { "", "", "", ">", "", "", "", "<" }         -- 仅显示垂直边框

              窗口边框中的标题
  title?: string | [text, highlight(default: FloatTitle)]
              标题位置(必须使用 `title` 选项设置。)
  title_pos?: "left" | "center" | "right"
              窗口边框中的页脚
  footer?: string | [text, highlight(default: FloatFooter)]
              页脚位置(必须使用 `title` 选项设置。)
  footer_pos?: "left" | "center" | "right" default: "left"

              是否屏蔽自动命令
  noautocmd: boolean
          如果为 true，则在调用期间所有自动命令都将被阻止

          是否保持浮动窗口固定
  fixed: boolean
          如果为 true，当锚点为 NW 或 SW 时，浮动窗口将保持固定，即使窗口被截断

          是否隐藏窗口
  hide: boolean
          如果为 true，浮动窗口将被隐藏。

          是否垂直分割
  vertical: boolean

          分割方向
  split：left"、"right"、"above"、"below"。
}

interface FloatWin {
  relative: "win" | "editor" | "mouse" | "cursor"
  win: number(window_ID) 创建浮动时的相对窗口
  anchor: "NW"(default) | "NE" | "SW" | "SE"
  width: number >=1
  height: number >=1
  bufpos: [line, columns] (0-based)
  row: number（允许小数）
  col: number（允许小数）
  focusable: boolean（default: true）
  zindex: number>=0
  style?: "minimal"
  border:
      | "none"
      | "single"
      | "double"
      | "rounded"
      | "solid"
      | "shadow"
      | Array
  title?: string | [text, highlight(default: FloatTitle)]
  title_pos?: "left" | "center" | "right"
  footer?: string | [text, highlight(default: FloatFooter)]
  footer_pos?: "left" | "center" | "right" default: "left"
  noautocmd: boolean
  fixed: boolean
  hide: boolean
}
-- 分屏窗口
interface NormalWin {
  win: number(window_ID) 要拆分的窗口
  anchor: "NW"(default) | "NE" | "SW" | "SE"
  width?: number >=1
  height?: number >=1
  focusable: boolean（default: true）
  zindex: number>=0
  style?: "minimal"
  noautocmd: boolean
  fixed: boolean
  hide: boolean
  vertical: boolean
  split：left"、"right"、"above"、"below"。
}

#### 注意
- 当 |textlock| 激活时不可调用
- 超出屏幕的浮动窗口会被内置实现截断
- 外部 GUI 可实现悬浮效果（但不建议用于任意定位）



API: nvim_win_get_config(win: number(window_ID)): 获取窗口配置信息

@return table 完整的窗口配置参数 === nvim_open_win -> config param

适用场景：
  1. 返回值可用于 |nvim_open_win()| 重新创建窗口
  2. 特定 config 的 callback

特别说明
- **坐标系差异**
  返回的 `row`/`col` 值可能与原始设置不同，因为：
  1. 内置实现会对非整数坐标取整
  2. 多网格 GUI 可能使用精确坐标
- **隐藏属性**
  通过 `nvim_win_hide()` 隐藏的窗口仍可获取配置
- **外部窗口**
  当 `external=true` 时，配置包含 GUI 特定参数（如像素尺寸）


API: nvim_win_set_config(window: number(window_ID), config: WinConfig)

重新配置窗口时，不会更改缺失的选项键。
`row`/`col` 和 `relative` 必须一起重新配置。


API: nvim_buf_call(buffer: number, fun: () => C): C 调用一个函数，将缓冲区作为临时当前缓冲区

这会暂时将当前缓冲区切换为“缓冲区”。
如果当前窗口已经显示“缓冲区”，则不会切换窗口。
如果当前标签页内的窗口（包括浮动窗口）已经显示缓冲区，则其中一个窗口将暂时设置为当前窗口。否则，将使用临时的临时窗口（由于历史原因，称为“自动命令窗口”）。

这很有用，例如，可以调用当前仅适用于当前缓冲区/窗口的 Vimscript 函数，如 |termopen()|。

属性：~
仅限 Lua |vim.api|

参数：~
• {buffer} 缓冲区句柄，或 0 表示当前缓冲区
• {fun} 在缓冲区内调用的函数（目前仅限 Lua 调用）

返回：~
函数的返回值。

API: nvim_win_call(window: number, fun: () => C): C  调用一个函数，将窗口作为临时当前窗口

核心作用: 在指定窗口的上下文中安全执行代码，同时保持原窗口焦点不变

@param
  -window: number(window_ID)
  -fun: () => C (callback)

@return callback 的执行结果

*注意*:
  1.同步执行: 函数内部代码会阻塞 Neovim 主线程，避免执行耗时操作（如网络请求）
  2.窗口有效性检查

      if vim.api.nvim_win_is_valid(target_win) then
        vim.api.nvim_win_call(target_win, func)
      end
  3.作用域限制：无法直接修改外层局部变量，需通过返回值传递数据

      local result
      vim.api.nvim_win_call(win, function()
        result = vim.api.nvim_get_current_line()
      end)
      print(result)


适用场景：
            场景                          示例
      1. 安全修改其他窗口内容	    在浮动窗口中插入文本而不抢夺焦点
      2. 跨窗口高亮操作	          在预览窗口添加语法高亮
      3. 维护插件状态	            在临时窗口执行搜索后自动关闭
      4. 批量窗口配置	            统一设置所有窗口的 wrap 选项
      5. 异步操作隔离	            在后台窗口执行耗时操作不影响用户交互

  1. 跨窗口安全操作, 在浮动窗口中插入文本而不抢夺焦点（无需手动切换窗口焦点即可操作其他窗口，避免焦点跳动干扰用户）

      -- 在窗口 1001 中插入文本但不切换焦点
      vim.api.nvim_win_call(1001, function()
        vim.api.nvim_put({'Hello from another window!'}, 'l', true, true)
      end)

  2. 批量窗口操作（对多个窗口执行相同操作时保持代码简洁）

      local wins = vim.api.nvim_tabpage_list_wins(0)
      for _, win in ipairs(wins) do
        vim.api.nvim_win_call(win, function()
          vim.wo.number = true -- 为所有窗口启用行号
        end)
      end

API: nvim_win_close(window: number, force: boolean) 关闭窗口 （类似 |:close| 并带有 |window-ID|）。

参数：~
• {window} 窗口句柄，或 0 表示当前窗口
• {force}   行为类似 `:close!` 可以关闭缓冲区中最后一个有未写入更改的窗口。即使未设置 'hidden'，缓冲区也将变为隐藏。

|textlock| 处于活动状态时不允许

API: nvim_win_hide(window: number)  关闭窗口并隐藏其包含的缓冲区（类似于带有|window-ID| 的 |:hide|）。

类似于 |:hide|，除非另一个窗口正在编辑它，否则缓冲区将隐藏，
或者 'bufhidden' 是 `unload`、`delete` 或 `wipe`，而不是 |:close|
或 |nvim_win_close()|，后者将关闭缓冲区。

属性：~
当 |textlock| 处于活动状态时不允许

参数：~
• {window} 窗口句柄，或 0 表示当前窗口

API: nvim_win_is_valid(window: number): boolean     检查窗口是否有效


API: nvim_set_var({name}, {value})                                 *nvim_set_var()*
    Sets a global (g:) variable.

    Parameters: ~
      • {name}   Variable name
      • {value}  Variable value

API: nvim_set_vvar({name}, {value})                               *nvim_set_vvar()*
    Sets a v: variable, if it is not readonly.

    Parameters: ~
      • {name}   Variable name
      • {value}  Variable value

API: nvim_win_set_var(window: number, name: string, value: any) 设置窗口范围 (w:) 变量

参数：~
• {window} 窗口句柄，或 0 表示当前窗口
• {name} 变量名称
• {value} 变量值

API: nvim_get_var({name})                                          *nvim_get_var()*
    Gets a global (g:) variable.

    Parameters: ~
      • {name}  Variable name

    Return: ~
        Variable value

API: nvim_get_vvar({name})                                        *nvim_get_vvar()*
    Gets a v: variable.

    Parameters: ~
      • {name}  Variable name

    Return: ~
        Variable value

API: nvim_win_get_var(window: number, name: string): any        获取窗口范围 (w:) 变量

参数：~
• {window} 窗口句柄，或 0 表示当前窗口
• {name} 变量名称

返回：~
变量值

API: nvim_del_var({name})
    Removes a global (g:) variable.

    Parameters: ~
      • {name}  Variable name

API: nvim_win_del_var(window: number, name: string)             删除窗口范围 (w:) 变量

参数：~
• {window} 窗口句柄，或 0 表示当前窗口
• {name} 变量名称

API: nvim_buf_del_var(buffer: number, name: string)
    Removes a buffer-scoped (b:) variable

    Parameters: ~
      • {buffer}  Buffer handle, or 0 for current buffer
      • {name}    Variable name












API: nvim_get_current_win()                                *nvim_get_current_win()*
    Gets the current window.

    Return: ~
        Window handle

API: nvim_set_current_win({window})                        *nvim_set_current_win()*
    Sets the current window.

    Attributes: ~
        not allowed when |textlock| is active or in the |cmdwin|

    Parameters: ~
      • {window}  Window handle

API: nvim_win_get_buf(window: number): number 获取窗口中的当前缓冲区

    Parameters: ~
      • {window}  Window handle, or 0 for current window

    Return: ~
        Buffer handle

API: nvim_win_get_cursor(window: number): [row, col]          获取给定窗口的索引、缓冲区相关的光标位置（显示同一缓冲区的不同窗口具有独立的光标位置）

参数：~
• {window} 窗口句柄，或 0 表示当前窗口

返回：~
(row, col) 元组

API: nvim_win_get_height(window: number): number  获取窗口高度

参数：~
• {window} 窗口句柄，或 0 表示当前窗口

返回：~
  高度作为行数 row

API: nvim_win_get_width(window: number): number   获取窗口宽度

参数：~
• {window} 窗口句柄，或 0 为当前窗口

返回：~
  宽度作为列数 col

API: nvim_win_set_height(window: number, height: number)    设置窗口高度

参数：~
• {window} 窗口句柄，或 0 为当前窗口
• {height} 高度作为行数


API: nvim_win_get_number(window: number): boolean 获取窗口编号

参数：~
• {window} 窗口句柄，或 0 表示当前窗口

返回：~
  窗口编号

API: nvim_win_set_width(window: number, width: number)      设置窗口宽度。仅当屏幕垂直分割时才会成功。

参数：~
• {window} 窗口句柄，或 0 为当前窗口
• {width} 宽度作为列数


API: nvim_win_get_position(window: number): [row, col]  获取窗口在显示单元中的位置。第一个位置为零。

参数：~
• {window} 窗口句柄，或 0 为当前窗口

返回：~
  带有窗口位置的 (row, col) 元组

API: nvim_win_get_tabpage(window: number): ???   获取窗口标签页

参数：~
• {window} 窗口句柄，或 0 为当前窗口

返回：~
  包含窗口的标签页


API: nvim_win_set_buf(window: number, buffer: number)    在窗口中设置当前缓冲区，没有副作用

属性：~
|textlock| 处于活动状态时不允许

参数：~
• {window} 窗口句柄，或 0 表示当前窗口
• {buffer} 缓冲区句柄

API: nvim_win_set_cursor(window: number, pos: [row, col])  在窗口中设置索引的光标位置。这会滚动窗口，即使它不是当前窗口。

参数：~
• {window} 窗口句柄，或 0 表示当前窗口
• {pos} (row, col) 元组表示新位置


API: nvim_win_set_hl_ns(window: number, ns_id: number) 为窗口设置高亮命名空间。这将使用 |nvim_set_hl()| 为该命名空间定义的高亮，但当缺失时将返回全局高亮 (ns=0)。

这优先于 'winhighlight' 选项。

参数：~
• {ns_id} 要使用的命名空间


API: nvim_win_text_height(window: number, opts?: table)    计算给定窗口中文本范围所占的屏幕行数。适用于屏幕外文本，并考虑折叠。

interface Opts {
• start_row： 起始行索引，从 0 开始（含）。省略时从最顶部开始。
• end_row：   结束行索引，从 0 开始，包括 0。省略时，结束于最底部。
• start_vcol："start_row" 上的起始虚拟列索引，从 0 开始，包括 0，向下舍入为全屏行。省略时，包括整行。
• end_vcol：  "end_row" 上的结束虚拟列索引，从 0 开始，不包括 0，向上舍入为全屏行。省略时，包括整行。
}

行上方的差异填充或虚拟行将计入该行的一部分，除非该行位于“start_row”上并且指定了“start_vcol”。

当省略“end_row”时，最后一个缓冲区行下方的差异填充或虚拟行将计入结果中。

行索引类似于 |nvim_buf_get_text()|。

参数：~
• {window} 窗口句柄，或 0 表示当前窗口。
• {opts} 可选参数：Opts

返回：~
包含文本高度信息的字典，具有以下键：
• all：范围占用的屏幕行总数。
• fill：其中不同的填充符或虚拟行数。

另请参阅：~
• |virtcol()| 用于文本宽度。






API:nvim_list_wins()                                            *nvim_list_wins()*
    Gets the current list of window handles.

    Return: ~
        List of window handles



API: nvim_get_all_options_info(): table   获取所有选项的选项信息

该字典包含完整的选项名称作为键和选项元数据字典

返回：~
  所有选项的字典

另请参阅：~
• |nvim_get_commands()|

API: nvim_get_option_info2(name: string, opts?: Opts): Info  从任意缓冲区或窗口获取一个选项的选项信息

interface Opts {
  scope："global" | "local"   分别类似于 |:setglobal| 和 |:setlocal|。
  win：window-ID              用于获取窗口本地选项。
  buf：缓冲区编号             用于获取缓冲区本地选项。
}

interface Info {
  name：            选项的名称（如“filetype”）
  shortname：       选项的缩写名称（如“ft”）
  type：            选项的类型（“string”、“number”或“boolean”）
  default：         选项的默认值
  was_set：         选项是否已设置。
  last_set_sid：    最后设置的脚本 ID（如果有）
  last_set_linenr： 设置选项的行号
  last_set_chan：   设置选项的通道（0 表示本地）
  scope："global | win" | "buf"
  global_local：win | buf 选项是否具有全局值
  commalist：       逗号分隔值的列表
  flaglist：        单个字符标志的列表
}

如果未提供 {scope}，则最后设置的信息适用于当前缓冲区或窗口中的本地值（如果可用），
否则返回全局值信息。
可以通过在 {opts} 表中明确指定 {scope} 来禁用此行为。

参数：~
• {name} 选项名称
• {opts} 可选参数
暗示 {scope} 是“本地”。

返回：~
选项信息



API: nvim_get_option_value(name: string, opts?: Opts): any   获取选项的值
此函数的行为与|:set| 的行为相同：如果选项存在，则返回其本地值；
否则返回全局值。
本地值始终对应于当前缓冲区或窗口，除非在 {opts} 中设置了“buf”或“win”。

interface Opts {
    scope："global" | "local"   分别类似于 |:setglobal| 和 |:setlocal|。
    win：|window-ID|            用于获取窗口本地选项。
    buf：缓冲区编号             用于获取缓冲区本地选项。暗示 {scope} 是“local”。
    filetype：|filetype|        用于获取特定文件类型的默认选项。不能与任何其他选项一起使用。
                                注意：这将触发 |ftplugin| 和所有 |FileType|对应文件类型的自动命令。
}

参数：~
• {name} 选项名称
• {opts} 可选参数

返回：~
选项值

API: nvim_set_option_value(name: string, value: any, opts? Open)  设置选项的值。

interface Opts {
 scope：“global” | “local”。分别类似于|:setglobal| 和 |:setlocal|。
 win：|window-ID|。         用于设置窗口本地选项。
 buf：缓冲区号。            用于设置缓冲区本地选项。
}

注意，选项 {win} 和 {buf} 不能一起使用。

此函数的行为与|:set|: 的行为相同，
对于全局-本地选项，除非使用 {scope} 另行指定，否则将同时设置全局值和本地值。

参数：~
• {name} 选项名称
• {value} 新选项值
• {opts} 可选参数










API: nvim_set_keymap({mode}, {lhs}, {rhs}, {opts})              *nvim_set_keymap()*
    Sets a global |mapping| for the given mode.

    To set a buffer-local mapping, use |nvim_buf_set_keymap()|.

    Unlike |:map|, leading/trailing whitespace is accepted as part of the
    {lhs} or {rhs}. Empty {rhs} is <Nop>. |keycodes| are replaced as usual.

    Example: >vim
        call nvim_set_keymap('n', ' <NL>', '', {'nowait': v:true})
<

    is equivalent to: >vim
        nmap <nowait> <Space><NL> <Nop>
<

    Parameters: ~
      • {mode}  Mode short-name (map command prefix: "n", "i", "v", "x", …)
                or "!" for |:map!|, or empty string for |:map|. "ia", "ca" or
                "!a" for abbreviation in Insert mode, Cmdline mode, or both,
                respectively
      • {lhs}   Left-hand-side |{lhs}| of the mapping.
      • {rhs}   Right-hand-side |{rhs}| of the mapping.
      • {opts}  Optional parameters map: Accepts all |:map-arguments| as keys
                except <buffer>, values are booleans (default false). Also:
                • "noremap" disables |recursive_mapping|, like |:noremap|
                • "desc" human-readable description.
                • "callback" Lua function called in place of {rhs}.
                • "replace_keycodes" (boolean) When "expr" is true, replace
                  keycodes in the resulting string (see
                  |nvim_replace_termcodes()|). Returning nil from the Lua
                  "callback" is equivalent to returning an empty string.

API: nvim_get_keymap({mode})                                    *nvim_get_keymap()*
    Gets a list of global (non-buffer-local) |mapping| definitions.

    Parameters: ~
      • {mode}  Mode short-name ("n", "i", "v", ...)

    Return: ~
        Array of |maparg()|-like dictionaries describing mappings. The"buffer" key is always zero.

API: nvim_buf_get_keymap({buffer}, {mode}): Array of |maparg()|
    Gets a list of buffer-local |mapping| definitions.

    Parameters: ~
      • {buffer}  Buffer handle, or 0 for current buffer
      • {mode}    Mode short-name ("n", "i", "v", ...)

    Return: ~
        Array of |maparg()|-like dictionaries describing mappings. The
        "buffer" key holds the associated buffer handle.

API: nvim_del_keymap({mode}, {lhs})
    Unmaps a global |mapping| for the given mode.

API: nvim_buf_del_keymap({buffer}, {mode}, {lhs})
    Unmaps a buffer-local |mapping| for the given mode.

    Parameters: ~
      • {buffer}  Buffer handle, or 0 for current buffer



API: nvim_get_mark({name}, {opts})
返回一个 `(row, col, buffer, buffername)` 元组，表示大写/文件命名标记的位置。
“行尾”列位置返回为 |v:maxcol|（大数字）。请参阅 |mark-motions|。

标记以 (1,0) 为索引。|api-indexing|

注意：~
• 小写名称（或其他缓冲区本地标记）是错误的。

参数：~
• {name} 标记名称
• {opts} 可选参数。保留以备将来使用。

返回：~
如果未设置标记，则为 4 元组 (row, col, buffer, buffername)，(0, 0, 0, '')。

API: nvim_buf_get_mark({buffer}, {name}): [row, col]
      获取命名标记的位置。

“行尾”列位置返回为 |v:maxcol|（大数字）。请参阅|mark-motions|。
标记以 (1,0) 为索引。|api-indexing|

参数：~
• {buffer} 缓冲区句柄，或 0（表示当前缓冲区）
• {name} 标记名称

返回：~
(row, col) 元组，如果未设置标记，或者是另一个缓冲区中设置的大写/文件标记，则返回 (0, 0)。

API: nvim_del_mark({name}): boolean
删除名为 mark 的大写字母/文件。请参阅 |mark-motions|。

注意：~
• 小写名称（或其他缓冲区本地标记）是错误的。

参数：~
• {name} 标记名称

返回：~
如果标记已被删除，则返回 true，否则返回 false。

API：nvim_buf_del_mark({buffer}, {name}): boolean  删除缓冲区中命名的标记
???
参数：~
• {buffer} 设置标记的缓冲区
• {name} 标记名称

返回：~
如果标记已删除，则返回 true，否则返回 false。

注意：~
• 仅删除缓冲区中设置的标记，如果缓冲区中未设置标记，则返回 false。

另请参阅：~
• |nvim_buf_set_mark()|
• |nvim_del_mark()|


API: nvim_create_buf(listed: boolean, scratch: boolean): number(buf-handle)
    创建一个新的、空的、未命名的缓冲区。

参数：~
• {listed} 是否设置 'buflisted'
• {scratch} 是否为临时工作创建一个“一次性” |scratch-buffer|
（始终为 'nomodified'）。还在缓冲区上设置 'nomodeline'。

返回：~
缓冲区句柄，或错误时为 0

API: nvim_buf_delete(buffer: number, opts?: Opts)       Deletes the buffer

interface Opts {
  force: Force deletion and ignore unsaved changes.
  unload: Unloaded only, do not delete
}

Attributes: ~
not allowed when |textlock| is active or in the |cmdwin|

Parameters: ~
• {buffer}  Buffer handle, or 0 for current buffer
• {opts}    Optional parameters. Keys:

API: nvim_get_current_buf()                                *nvim_get_current_buf()*
    Gets the current buffer.

    Return: ~
        Buffer handle

API:nvim_set_current_buf({buffer})                        *nvim_set_current_buf()*
    Sets the current buffer.

    Attributes: ~
        not allowed when |textlock| is active or in the |cmdwin|

    Parameters: ~
      • {buffer}  Buffer handle

API:nvim_list_bufs()                                            *nvim_list_bufs()*
    Gets the current list of buffer handles

    Includes unlisted (unloaded/deleted) buffers, like `:ls!`. Use
    |nvim_buf_is_loaded()| to check if a buffer is loaded.

    Return: ~
        List of buffer handles



API：nvim_buf_get_lines({buffer}, {start}, {end}, {strict_indexing}: boolean): line[]
    从缓冲区获取行范围。

索引从 0 开始，不包括末尾。

负索引被解释为length+1+index：-1 指的是末尾之后的索引。
因此，要获取最后一个元素，请使用 start=-2 和 end=-1。
越界索引将被限制为最接近的有效值，除非`strict_indexing` 已设置。

参数：~
• {buffer} 缓冲区句柄，或当前缓冲区的 0
• {start} 第一行索引
• {end} 最后行索引，不包括
• {strict_indexing} 越界是否应为错误。

返回：~
行数组，或未加载缓冲区的空数组。

API: nvim_get_current_line()                              *nvim_get_current_line()*
    Gets the current line.

    Return: ~
        Current line string

API: nvim_del_current_line()
    Deletes the current line.

    Attributes: ~
        not allowed when |textlock| is active


API: nvim_echo(chunks: [text, hl_group], history: boolean, opts?: Opts)
    回显一条消息

interface Opts {
  verbose：如果使用 -V3log_file 调用 Nvim，则消息作为 'verbose' 选项的结果打印，消息将被重定向到 log_file 并从直接输出中抑制。
}

参数：~
• {chunks} `[text, hl_group]` 数组列表，每个数组代表一个带有指定高亮显示的文本块。`hl_group` 元素可以省略，表示不高亮显示。
• {history} 如果为真，则添加到 |message-history|。
• {opts} 可选参数。

API: nvim_err_write({str})
将消息写入 Vim 错误缓冲区。不附加“\n”，消息将被缓冲（不会显示），直到写入换行符。

参数：~
• {str} 消息

API: nvim_err_writeln({str})
将消息写入 Vim 错误缓冲区。附加“\n”，因此缓冲区将被刷新（并显示）。

参数：~
• {str} 消息


API: nvim_eval_statusline({str}: 状态行字符串（参见 'statusline'）, {opts}): Return
    评估状态行字符串。

    interface Opts {
      winid：number               用作状态行上下文的窗口的 |window-ID|。
      maxwidth：number            状态行的最大宽度。
      fillchar：string            用于填充状态行中空白的字符（参见 'fillchars'）。即使不是单宽度，也视为单宽度。
      highlight：boolean          返回突出显示信息。
      use_winbar：boolean         评估 winbar 而不是状态行。
      use_tabline：boolean        评估 tabline 而不是状态行。当为 true 时，将忽略 {winid}。与 {use_winbar} 互斥。
      use_statuscol_lnum：number  评估此行号（而不是状态行）的状态列。
    }

    interface Return {
      • str：（字符串） 将显示在状态行上的字符。
      • width：number   显示状态行的宽度。
      • highlight：     包含状态行突出显示信息的数组。仅当 {opts} 中的“highlights”键为 true 时才包含。数组的每个元素都是一个 |Dictionary|，具有以下键：
      • start：number   使用突出显示的第一个字符的字节索引（从 0 开始）。
      • group：（字符串）突出显示组的名称。
    }



API: nvim_exec_lua({code}, {args})
      执行 Lua 代码。参数（如果有）在块内以 `...` 形式提供。块可以返回值。

仅执行语句。要评估表达式，请在其前面加上 `return`：return my_function(...)

参数：~
• {code} 要执行的 Lua 代码
• {args} 代码的参数

返回：~
如果存在，则返回 Lua 代码的值，否则为 NIL。

-- 执行简单打印语句
vim.api.nvim_exec_lua([[
print("Hello from Lua!")
\]\], {})
-- 输出：Hello from Lua!
-- 返回：nil（无返回值）

-- 计算阶乘
local code = [[
  local n = ...
  local fact = 1
  for i=2,n do fact = fact * i end
  return fact
\]\]

local result = vim.api.nvim_exec_lua(code, {5})
print(result) --> 120


API：nvim_get_color_by_name({name}) *nvim_get_color_by_name()*
    返回 |nvim_get_color_map()| 颜色名称或“#rrggbb” 十六进制字符串的 24 位 RGB 值。

参数：~
  - {name} 颜色名称或“#rrggbb”字符串

返回：~
  - 24 位 RGB 值，或 -1（表示参数无效）。

示例：vim
:echo nvim_get_color_by_name("Pink")
:echo nvim_get_color_by_name("#cbcbcb")

API: nvim_get_color_map() *nvim_get_color_map()*
返回颜色名称和 RGB 值的映射。

键是颜色名称（例如“Aqua”），值是 24 位 RGB 颜色值
（例如 65535）。

返回：~
颜色名称和 RGB 值的映射。

API: nvim_get_context({opts}) *nvim_get_context()*
获取当前编辑器状态的映射。

参数：~
• {opts} 可选参数。
• 类型：要收集的 |context-types| 列表（“regs”、“jumps”、“bufs”、“gvars”……），或为空以表示“全部”。

返回：~
全局 |context| 映射。


API: nvim_get_hl({ns_id}, {opts})
  获取命名空间中所有或特定的高亮组。

  interface Opts {
    name：string 通过名称获取高亮定义。
    id：整数     通过 id 获取高亮定义。
    link：（布尔值，默认 true）显示链接组名称而不是有效定义 |:hi-link|。
    create：（布尔值，默认 true）当高亮组不存在时创建它。
  }

注意：~
• 当在高亮定义映射中定义 `link` 属性时，
其他属性将不会生效（参见 |:hi-link|）。

参数：~
• {ns_id} 获取命名空间 ns_id 的高亮组|nvim_get_namespaces()|。使用 0 获取全局高亮组|:highlight|。
• {opts} 选项字典：

返回：~
高亮组作为从组名到高亮定义的
映射，如 |nvim_set_hl()| 中所示，或者仅作为单个高亮定义映射（如果按名称或 ID 请求）。

API: nvim_get_hl_id_by_name({name}) *nvim_get_hl_id_by_name()*
根据名称获取高亮组

类似于 |hlID()|，但如果不存在则分配新 ID。

API: nvim_get_hl_ns({opts}) *nvim_get_hl_ns()*
获取活动的高亮命名空间。

参数：~
• {opts} 可选参数
• winid：（数字）|window-ID| 用于检索窗口的高亮命名空间。当尚未为窗口调用 |nvim_win_set_hl_ns()| 时（或使用命名空间 -1 调用），将返回值 -1。

返回：~
命名空间 ID，或 -1


API: nvim_get_mode()                                              *nvim_get_mode()*
    Gets the current mode. |mode()| "blocking" is true if Nvim is waiting for
    input.

    Attributes: ~
        |api-fast|

    Return: ~
        Dictionary { "mode": String, "blocking": Boolean }

API: nvim_get_proc({pid}) *nvim_get_proc()*
获取描述进程 `pid` 的信息。

返回：~
进程属性映射，如果未找到进程，则返回 NIL。

API:nvim_get_proc_children({pid})                       *nvim_get_proc_children()*
    Gets the immediate children of process `pid`.

    Return: ~
        Array of child process ids, empty if process not found.


API: nvim_get_runtime_file({name}, {all})
在运行时目录中查找文件

“name” 可以包含通配符。例如
nvim_get_runtime_file("colors/*.vim", true) 将返回所有配色方案
文件。无论平台如何，在搜索子目录的模式中始终使用正斜杠 (/)。

找不到任何文件并不是一种错误。然后会返回一个空数组。

属性：~
|api-fast|

参数：~
• {name} 要搜索的文件模式
• {all} 是返回所有匹配项还是仅返回第一个

返回：~
找到的文件的绝对路径列表

API:nvim_list_runtime_paths()                          *nvim_list_runtime_paths()*
    Gets the paths contained in |runtime-search-path|.

    Return: ~
        List of paths

API: nvim_input({keys}) *nvim_input()*
将原始用户输入排队。与 |nvim_feedkeys()| 不同，它使用低级输入缓冲区，并且调用是非阻塞的（输入由事件循环异步处理）。

执行错误时：不会失败，但会更新 v:errmsg。

注意：~
• |keycodes| 像 <CR> 一样被翻译，因此“<”是特殊的。要输入文字“<”，请发送 <LT>。
• 对于鼠标事件，请使用 |nvim_input_mouse()|。伪键形式
`<LeftMouse><col,row>` 自 |api-level| 6 起已弃用。

属性：~
|api-fast|

参数：~
• 要输入的 {keys}

返回：~
实际写入的字节数（如果缓冲区已满，则可能少于请求的字节数）。

API: nvim_input_mouse({button}, {action}, {modifier}, {grid}, {row}, {col})
从 GUI 发送鼠标事件。

非阻塞：不等待任何结果，但将事件排队以便事件循环尽快处理。

注意：~
• 目前，这不支持通过在循环中多次调用它来“编写”多个鼠标事件：中间鼠标位置将被忽略。它应该用于在 GUI 中实现实时鼠标输入。|nvim_input()| 的已弃用的伪键形式 (`<LeftMouse><col,row>`) 具有相同的限制。

属性：~
|api-fast|

参数：~
• {button} 鼠标按钮：“左”、“右”、“中”、“滚轮”、“移动”、“x1”、“x2”之一。
• {action} 对于普通按钮，为“按下”、“拖动”、“释放”之一。
对于滚轮，为“上”、“下”、“左”、“右”之一。
对于“移动”忽略。
• {modifier} 修饰符字符串，每个修饰符由单个字符表示。
与按键使用相同的说明符，但“-”分隔符是可选的，因此“C-A-”、“c-a”和“CA”
都可用于指定 Ctrl+Alt+单击。
• {grid} 如果客户端使用 |ui-multigrid|，则为网格编号，否则为 0。
• {row} 鼠标行位置（从零开始，与重绘事件类似）
• {col} 鼠标列位置（从零开始，与重绘事件类似）

API:nvim_notify({msg}, {log_level}, {opts}) *nvim_notify()*
通过消息通知用户

将调用中继到 vim.notify 。默认情况下，在
回显区域中转发您的消息，但可以覆盖以触发桌面通知。

参数：~
• {msg} 要显示给用户的消息
• {log_level} 日志级别
• {opts} 保留以备将来使用。


API:nvim_open_term({buffer}, {opts}) *nvim_open_term()*
在缓冲区中打开终端实例

默认情况下（目前是唯一的选项），终端不会连接到外部进程。相反，通道上发送的输入将直接由终端回显。这对于显示作为 rpc 消息的一部分返回的 ANSI 终端序列或类似消息非常有用。

注意：要使用正确的大小直接启动终端，请在调用此函数之前在配置的窗口中显示缓冲区。例如，对于浮动显示，首先使用 |nvim_create_buf()| 创建一个空缓冲区，然后使用 |nvim_open_win()| 显示它，然后调用此函数。然后可以立即调用 |nvim_chan_send()| 来处理具有预期大小的虚拟终端中的序列。

属性：~
当 |textlock| 时不允许处于活动状态

参数：~
• {buffer} 要使用的缓冲区（应为空）
• {opts} 可选参数。
• on_input：Lua 回调，用于发送输入，即终端模式下的按键。注意：按键以原始方式发送到 pty 主端。例如，回车符作为“\r”而不是“\n”发送。|textlock| 适用。但是，可以在回调中直接调用 |nvim_chan_send()|。`["input", term, bufnr, data]`
• force_crlf：（布尔值，默认为 true）将“\n”转换为“\r\n”。

返回：~
通道 ID，或错误时为 0

API:nvim_out_write({str}) *nvim_out_write()*
将消息写入 Vim 输出缓冲区。不附加“\n”，
消息将被缓冲（不会显示），直到写入换行符。

参数：~
• {str} 消息


API:nvim_paste({data}, {crlf}, {phase}) *nvim_paste()*
在任何模式下，在光标处粘贴。

调用 `vim.paste` 处理程序，该处理程序会适当处理每种模式。

设置重做/撤消。比 |nvim_input()| 更快。在 LF（“\n”）处换行。

错误（“nomodifiable”、“vim.paste()”失败等）反映在 `err` 中
但不影响返回值（由
`vim.paste()` 严格决定）。出现错误时，后续调用将被忽略（“耗尽”），直到
启动下一个粘贴（阶段 1 或 -1）。

属性：~
当 |textlock| 处于活动状态时不允许

参数：~
• {data} 多行输入。可以是二进制（包含 NUL 字节）。
• {crlf} 也在 CR 和 CRLF 处换行。
• {phase} -1：在单个调用中粘贴（即不进行流式传输）。要“流式传输”粘贴，请使用以下“phase”值按顺序调用“nvim_paste”：
• 1：开始粘贴（恰好一次）
• 2：继续粘贴（零次或多次）
• 3：结束粘贴（恰好一次）

返回：~
• true：客户端可以继续粘贴。
• false：客户端必须取消粘贴。

API: nvim_put({lines}, {type}, {after}, {follow}) *nvim_put()*
在任何模式下，将文本放在光标处。

比较 |:put| 和 |p|，它们始终是逐行的。

属性：~
|textlock| 处于活动状态时不允许

参数：~
• {lines} |readfile()| 样式的行列表。|channel-lines|
• {type} 编辑行为：任何 |getregtype()| 结果，或：
• "b" |blockwise-visual| 模式（可能包括宽度，例如 "b3"）
• "c" |charwise| 模式
• "l" |linewise| 模式
• "" 根据内容猜测，参见 |setreg()|
• {after} 如果为 true，则在光标后插入（类似 |p|），或在光标前插入（类似
|P|）。
• {follow} 如果为 true，则将光标放在插入文本的末尾。


API:nvim_select_popupmenu_item({item}, {insert}, {finish}, {opts})
在完成弹出菜单中选择一个项目。

如果 |ins-completion| 和 |cmdline-completion| 弹出菜单均未激活，则此 API 调用将被忽略。对于使用 |ui-popupmenu| 用鼠标控制弹出菜单的外部 UI 很有用。也可以在映射中使用；使用 <Cmd> |:map-cmd| 或 Lua 映射来确保映射不会结束完成模式。

参数：~
• {item} 要选择的项目的索引（从零开始）。值为 -1
表示不选择任何内容并恢复原始文本。
• {insert} 对于 |ins-completion|，是否应将选择插入缓冲区。对于 |cmdline-completion| 忽略。
• {finish} 完成完成并关闭弹出菜单。暗示
{insert}。
• {opts} 可选参数。保留以供将来使用。



API: nvim_set_current_dir({dir})                           *nvim_set_current_dir()*
    Changes the global working directory.

    Parameters: ~
      • {dir}  Directory path


API: nvim_set_hl({ns_id}, {name}, {val}) *nvim_set_hl()*
设置高亮组。

注意：~
• 与可以更新高亮组的 `:highlight` 命令不同，
此函数完全替换定义。例如：
`nvim_set_hl(0, 'Visual', {})` 将清除高亮组
'Visual'。
• fg 和 bg 键还接受字符串值 `"fg"` 或 `"bg"`
它们充当 Normal 组相应前景和背景值的别名。如果 Normal 组尚未定义，
使用这些值会导致错误。
• 如果 `link` 与其他属性结合使用；只有
`link` 会生效（参见 |:hi-link|）。

参数：~
• {ns_id} 此高亮的命名空间 id |nvim_create_namespace()|。
使用 0 全局设置高亮组 |:highlight|。

非全局命名空间的高亮默认不处于活动状态，使用 |nvim_set_hl_ns()| 或 |nvim_win_set_hl_ns()| 来

激活它们。
• {name} 高亮组名称，例如“ErrorMsg”
• {val} 高亮定义映射，接受以下键：
• fg：颜色名称或“#RRGGBB”，参见注释。
• bg：颜色名称或“#RRGGBB”，参见注释。
• sp：颜色名称或“#RRGGBB”
• blend：0 到 100 之间的整数
• bold：布尔值
• standout：布尔值
• underline：布尔值
• undercurl：布尔值
• underdouble：布尔值
• underdotted：布尔值
• underdashed：布尔值
• strikethrough：布尔值
• italic：布尔值
• reverse：布尔值
• nocombine：布尔值
• link：要链接到的另一个高亮组的名称，请参阅
|:hi-link|。
• default：不覆盖现有定义 |:hi-default|
• ctermfg：设置 cterm 颜色的前景 |ctermfg|
• ctermbg：设置 cterm 颜色的背景 |ctermbg|
• cterm：cterm 属性映射，如 |highlight-args|。如果未设置，cterm 属性将与上面记录的属性映射中的属性相匹配。
• force：如果 true，则强制更新高亮组（如果存在）。

API: nvim_set_hl_ns({ns_id}) *nvim_set_hl_ns()*
为使用 |nvim_set_hl()| 定义的高亮设置活动命名空间。这可以为单个窗口设置，请参阅 |nvim_win_set_hl_ns()|。

参数：~
• {ns_id} 要使用的命名空间


API: nvim_strwidth({text}) *nvim_strwidth()*
计算 `text` 占用的显示单元数。控制字符（包括 <Tab>）计为一个单元。

参数：~
• {text} 一些文本

返回：~
单元数


API: nvim_call_dict_function({dict}, {fn}, {args})
使用给定的参数调用 Vimscript |Dictionary-function|。

执行错误时：失败并出现 Vimscript 错误，更新 v:errmsg。

参数：~
• {dict} 字典，或字符串，计算结果为 Vimscript |self| 字典
• {fn} 在 Vimscript 字典上定义的函数名称
• {args} 函数参数打包在数组中

返回：~
函数调用结果

API: nvim_call_function({fn}, {args}) *nvim_call_function()*
使用给定的参数调用 Vimscript 函数。

执行错误时：失败并出现 Vimscript 错误，更新 v:errmsg。

参数：~
• {fn} 要调用的函数
• {args} 函数参数打包在数组中

返回：~
函数调用结果

API: nvim_command({command}) *nvim_command()*
执行 Ex 命令。

执行错误时：失败并出现 Vimscript 错误，更新 v:errmsg。

最好使用 |nvim_cmd()| 或 |nvim_exec2()|。
要直接评估多行 Vim 脚本或 Ex 命令，请使用|nvim_exec2()|。
要使用结构化格式构造 Ex 命令并然后执行它，请使用 |nvim_cmd()|。
要在评估 Ex 命令之前对其进行修改，请结合使用 |nvim_parse_cmd()| 和 |nvim_cmd()|。

参数：~
• {command} Ex 命令字符串

API: nvim_exec2({src}, {opts}) *nvim_exec2()*
执行 Vimscript（多行 Ex 命令块），类似 anonymous|:source|。

与 |nvim_command()| 不同，此函数支持 heredocs、script-scope(s:) 等。

执行错误时：失败并出现 Vimscript 错误，更新 v:errmsg。

参数：~
• {src} Vimscript 代码
• {opts} 可选参数。
• output：（布尔值，默认为 false）是否捕获并返回所有（非错误、非 shell |:!|）输出。

返回：~
包含有关执行的信息的字典，具有以下键：
• output：（string|nil）如果 `opts.output` 为真，则输出。

API: nvim_cmd({cmd}, {opts}) *nvim_cmd()*
执行 Ex 命令。

与 |nvim_command()| 不同，此命令采用结构化字典而不是字符串。
这样可以更轻松地构造和操作 Ex命令。
这还允许在命令参数内使用空格、在不扩展文件名的命令中扩展文件名等。
命令参数也可以是数字、布尔值或字符串。

对于支持 count 的命令，也可以使用第一个参数代替 count，以便通过 |vim.cmd()| 更轻松地使用它们。例如，您可以执行 `vim.cmd.bdelete(2)`，而不是 `vim.cmd.bdelete{ count = 2 }`。

执行错误时：失败并出现 Vimscript 错误，更新 v:errmsg。

参数：~
• {cmd} 要执行的命令。必须是一个字典，可以包含
与 |nvim_parse_cmd()| 的返回值相同的值，但“addr”、“nargs”和“nextcmd”除外，如果提供，则忽略它们。
除了“cmd”之外的所有值都是可选的。
• {opts} 可选参数。
• output：（布尔值，默认为 false）是否返回命令
输出。

返回：~
如果 `output` 为真，则返回命令输出（非错误、非 shell |:!|），否则
为空字符串。

另请参阅：~
• |nvim_exec2()|
• |nvim_command()|



API:nvim_eval({expr}) *nvim_eval()*
评估 Vimscript |表达式|。字典和列表以递归方式
展开。

执行错误时：失败并出现 Vimscript 错误，更新 v:errmsg。

参数：~
• {expr} Vimscript 表达式字符串

返回：~
评估结果或展开的对象

nvim_parse_expression({expr}, {flags}, {highlight})
    Parse a Vimscript expression.

    Attributes: ~
        |api-fast|

    Parameters: ~
      • {expr}       Expression to parse. Always treated as a single line.
      • {flags}      Flags:
                     • "m" if multiple expressions in a row are allowed (only
                       the first one will be parsed),
                     • "E" if EOC tokens are not allowed (determines whether
                       they will stop parsing process or be recognized as an
                       operator/space, though also yielding an error).
                     • "l" when needing to start parsing with lvalues for
                       ":let" or ":for". Common flag sets:
                     • "m" to parse like for `":echo"`.
                     • "E" to parse like for `"<C-r>="`.
                     • empty string for ":call".
                     • "lm" to parse for ":let".
      • {highlight}  If true, return value will also include "highlight" key
                     containing array of 4-tuples (arrays) (Integer, Integer,
                     Integer, String), where first three numbers define the
                     highlighted region and represent line, starting column
                     and ending column (latter exclusive: one should highlight
                     region [start_col, end_col)).

    Return: ~
        • AST: top-level dictionary with these keys:
          • "error": Dictionary with error, present only if parser saw some
            error. Contains the following keys:
            • "message": String, error message in printf format, translated.
              Must contain exactly one "%.*s".
            • "arg": String, error message argument.
          • "len": Amount of bytes successfully parsed. With flags equal to ""
            that should be equal to the length of expr string. ("Successfully
            parsed" here means "participated in AST creation", not "till the
            first error".)
          • "ast": AST, either nil or a dictionary with these keys:
            • "type": node type, one of the value names from ExprASTNodeType
              stringified without "kExprNode" prefix.
            • "start": a pair `[line, column]` describing where node is
              "started" where "line" is always 0 (will not be 0 if you will be
              using this API on e.g. ":let", but that is not present yet).
              Both elements are Integers.
            • "len": “length” of the node. This and "start" are there for
              debugging purposes primary (debugging parser and providing debug
              information).
            • "children": a list of nodes described in top/"ast". There always
              is zero, one or two children, key will not be present if node
              has no children. Maximum number of children may be found in
              node_maxchildren array.
        • Local values (present only for certain nodes):
          • "scope": a single Integer, specifies scope for "Option" and
            "PlainIdentifier" nodes. For "Option" it is one of ExprOptScope
            values, for "PlainIdentifier" it is one of ExprVarScope values.
          • "ident": identifier (without scope, if any), present for "Option",
            "PlainIdentifier", "PlainKey" and "Environment" nodes.
          • "name": Integer, register name (one character) or -1. Only present
            for "Register" nodes.
          • "cmp_type": String, comparison type, one of the value names from
            ExprComparisonType, stringified without "kExprCmp" prefix. Only
            present for "Comparison" nodes.
          • "ccs_strategy": String, case comparison strategy, one of the value
            names from ExprCaseCompareStrategy, stringified without
            "kCCStrategy" prefix. Only present for "Comparison" nodes.
          • "augmentation": String, augmentation type for "Assignment" nodes.
            Is either an empty string, "Add", "Subtract" or "Concat" for "=",
            "+=", "-=" or ".=" respectively.
          • "invert": Boolean, true if result of comparison needs to be
            inverted. Only present for "Comparison" nodes.
          • "ivalue": Integer, integer value for "Integer" nodes.
          • "fvalue": Float, floating-point value for "Float" nodes.
          • "svalue": String, value for "SingleQuotedString" and
            "DoubleQuotedString" nodes.

API: nvim_create_user_command({name}, {command}, {opts})
创建一个全局 |user-commands| 命令。

有关 Lua 用法，请参阅 |lua-guide-commands-create|。

示例：>vim
:call nvim_create_user_command('SayHello', 'echo "Hello world!"', {'bang': v:true})
:SayHello
Hello world!
<

参数：~
• {name} 新用户命令的名称。必须以大写字母开头。
• {command} 执行此用户命令时要执行的替换命令。从 Lua 调用时，该命令也可以是 Lua 函数。该函数使用一个表
参数调用，该表包含以下键：
• name：（字符串）命令名称
• args：（字符串）传递给命令的参数（如果有）
<args>
• fargs：（表）由未转义的空格分隔的参数
（当允许多个参数时），如果有 <f-args>
• nargs：（字符串）参数数量 |:command-nargs|
• bang：（布尔值）如果命令是使用
执行的，则为“true”！修饰符 <bang>
• line1：（数字）命令范围的起始行
<line1>
• line2：（数字）命令范围的最后一行
<line2>
• range：（数字）命令范围内的项目数：
0、1 或 2 <range>
• count：（数字）提供的任何计数 <count>
• reg：（字符串）可选寄存器（如果指定）<reg>
• mods：（字符串）命令修饰符（如果有）<mods>
• smods：（表）结构化格式的命令修饰符。
与 |nvim_parse_cmd()| 的“mods”键具有相同的结构。
• {opts} 可选 |command-attributes|。
• 设置布尔属性，例如 |:command-bang| 或
|:command-bar|为 true（但不是 |:command-buffer|，而是使用
|nvim_buf_create_user_command()|）。
• “complete” |:command-complete| 还接受 Lua
函数，其工作方式类似于
|:command-completion-customlist|。
• 其他参数：
• desc：（字符串）用于在 Lua
函数用于 {command} 时列出命令。
• force：（布尔值，默认为 true）覆盖任何先前的
定义。
• preview：（函数）“inccommand”的预览回调
|:command-preview|

API: nvim_buf_create_user_command({buffer}, {name}, {command}, {opts})
创建缓冲区本地命令 |user-commands|。

参数：~
• {buffer} 缓冲区句柄，或 0 表示当前缓冲区。

另请参阅：~
• nvim_create_user_command

API: nvim_del_user_command({name})                        *nvim_del_user_command()*
    Delete a user-defined command.

    Parameters: ~
      • {name}  Name of the command to delete.

API: nvim_buf_del_user_command({buffer}, {name})
删除缓冲区本地用户定义命令。

仅使用 |:command-buffer| 或
|nvim_buf_create_user_command()| 创建的命令才可使用该函数删除。

参数：~
• {buffer} 缓冲区句柄，或 0 为当前缓冲区。
• {name} 要删除的命令的名称。

API: nvim_buf_get_commands({buffer}, {opts}) *nvim_buf_get_commands()*
获取缓冲区本地 |user-commands| 的映射。

参数：~
• {buffer} 缓冲区句柄，或 0 为当前缓冲区
• {opts} 可选参数。当前未使用。

返回：~
描述命令的映射的映射。

API: nvim_parse_cmd({str}, {opts}) *nvim_parse_cmd()*
解析命令行。

不检查命令参数的有效性。

属性：~
|api-fast|

参数：~
• {str} 要解析的命令行字符串。不能包含“\n”。
• {opts} 可选参数。保留以备将来使用。

返回：~
包含命令信息的字典，具有以下键：
• cmd：（字符串）命令名称。
• range：（数组）（可选）命令范围（<line1> <line2>）。如果命令不接受范围，则省略。否则，如果未指定范围，则没有元素；如果仅指定了一个范围项，则有一个元素；如果指定了两个范围项，则有两个元素。
• count：（数字）（可选）命令 <count>。如果命令不能进行计数，则省略。
• reg：（字符串）（可选）命令 <register>。如果命令
不能使用寄存器，则省略。
• bang：（布尔值）命令是否包含 <bang> (!) 修饰符。
• args：（数组）命令参数。
• addr：（字符串）|:command-addr| 的值。使用短名称或“line”表示 -addr=lines。
• nargs：（字符串）|:command-nargs| 的值。
• nextcmd：（字符串）如果有多个命令，则由 |:bar| 分隔，则为下一个命令。如果没有下一个命令，则为空。
• magic：（字典）命令参数中哪些字符具有特殊含义。
• file：（布尔值）命令扩展文件名。这意味着扩展了诸如“%”、“#”和通配符之类的字符。
• bar：（布尔值）“|”字符被视为命令分隔符
，双引号字符 (") 被视为注释的开头。
• mods: (字典) |:command-modifiers|。
• filter: (字典) |:filter|。
• pattern: (字符串) 过滤器模式。如果没有过滤器，则为空字符串。
• force: (布尔值) 过滤器是否反转。
• silent: (布尔值) |:silent|。
• emsg_silent: (布尔值) |:silent!|。
• unsilent: (布尔值) |:unsilent|。
• sandbox: (布尔值) |:sandbox|。
• noautocmd: (布尔值) |:noautocmd|。
• browser: (布尔值) |:browse|。
• confirmed: (布尔值) |:confirm|。
• hide: (布尔值) |:hide|。
• Horizo​​ntal: (布尔值) |:horizo​​ntal|。
• keepalt：（布尔值）|:keepalt|。
• keepjumps：（布尔值）|:keepjumps|。
• keepmarks：（布尔值）|:keepmarks|。
• keeppatterns：（布尔值）|:keeppatterns|。
• lockmarks：（布尔值）|:lockmarks|。
• noswapfile：（布尔值）|:noswapfile|。
• tab：（整数）|:tab|。省略时为 -1。
• verbose：（整数）|:verbose|。省略时为 -1。
• vertical：（布尔值）|:vertical|。
• split：（字符串）拆分修饰符字符串，当没有拆分修饰符时为空字符串。如果有拆分修饰符，则可以是以下之一：
• “aboveleft”：|:aboveleft|。
• “belowright”：|:belowright|。
• “左上”：|:左上|。
• “右下”：|:右下|。
--]]
