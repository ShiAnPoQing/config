--[[
Option type:
  global
  local to buffer
  local to window
  global or local to buffer
  global or local to window 

每一种选项类型都有 local value 和 global value

:set        设置 local value 和 global value
:setlocal   设置 local value
:setglobal  设置 global value


global: 强调不同 buffer 的 option 的一致性
      1. 所有 buffer: global/local value 是该 buffer 的 Effect value

      注意：local 和 global 公用一个 value 表，所以 local value 与 global value 总是一样的
          所以：
            set option=value
            setglobal option? -> value
            setlocal option? -> value

            setglobal option=value
            setlocal option? -> value

            setlocal option=value
            setglobal option? -> value

local to buffer: 强调不同 buffer 的 option 的独立性
              1. 所有 buffer: local value 是该 buffer 的 Effect value，而 local value 初始化为 global value

                 global value
                      │
                      ├── Buffer A → local value
                      ├── Buffer B → local value
                      └── Buffer C → local value

              :setlocal       当前 buffer

local to window: 强调不同 buffer 的 option 的独立性，强调相同 buffer 的 option 在不同 window 中的独立性
              1. 特定窗口中的 buffer：local value 是该 buffer 的 Effect value，而 local value 初始化为 global value

                      ┌── Buffer A → local value1
                      ├── Buffer B → local value1
                   Window B
                      │
                 global value
                      │
                   Window A
                      ├── Buffer A → local value2
                      └── Buffer B → local value2

              :setlocal       当前窗口下的当前 buffer

global or local to buffer: 强调特定 buffer 的 option 的特殊性
              1. 未指定 local value 的 buffer：则 global value 是该 buffer 的 Effect value
              2. 指定了 local value 的 buffer：则 local value 是该 buffer 的 Effect value，而 local value 初始化为 global value

                 global value
                      │
                      ├── Buffer A → local value
                      ├── Buffer B → local value
                      └── Buffer C → global value(未指定 local value)

              :setlocal       当前 buffer

global or local to window: 强调在特定 buffer 的 option 的特殊性，强调特定 buffer 的 option 在特定 window 中的特殊性
              1. 特定窗口中未指定 local value 的 buffer：则 global value 是该 buffer 的 Effect value
              2. 特定窗口中指定了 local value 的 buffer：则 local value 是该 buffer 的 Effect value，而 local value 初始化为 global value

                      ┌── Buffer A → global value(在该窗口中未指定 local value)
                      ├── Buffer B → local value1
                   Window B
                      │
                 global value
                      │
                   Window A
                      ├── Buffer A → local value2
                      └── Buffer B → global value(在该窗口中未指定 local value)

              :setlocal       当前窗口下的当前 buffer

:set 命令
  缺点：setlocal 只相对于当前 buffer，不够灵活

vim.opt           是 :set 的 lua 实现
vim.opt_local     是 :setlocal 的 lua 实现
vim.opt_global    是 :setglobal 的 lua 实现

---------------------------------------------------------------------------------------------------
              命令         全局值    本地值     条件
       :set option=value    设置      设置
  :setlocal option=value    -         设置
 :setglobal option=value    设置      -

       :set option?         -         显示    本地值已设置
       :set option?         显示      -       本地值未设置
  :setlocal option?         -         显示
 :setglobal option?         显示      -
---------------------------------------------------------------------------------------------------

vim.o 等命令
  增加了 setlocal 的灵活性，可以指定 buffer 或者指定 window 下的 current buffer

  使用思路：
    1. 确定 Option 类型
    2. 确定要设置的 value 类型：local value 或者 global value 或者 local and global value
    3. 根据需求选择对应的 Lua 接口

---------------------------------------------------------------------------------------------------
Lua                        Like               option type
vim.o                      :set               global
                                              local to buffer/global or local to buffer(:setlocal: 设置当前 buffer 的 local value)
                                              local to window/global or local to window(:setlocal: 设置当前 window 下的 current buffer 的 local value)

vim.go                     :setglobal         ALL

vim.bo[{bufnr}]            :setlocal          local to buffer
                           :setlocal          global or local to buffer

vim.wo[{winid}]            :set               local to window
                           :setlocal          global or local to window
vim.wo[w][0]               :setlocal          local to window
                           :setlocal          global or local to window
---------------------------------------------------------------------------------------------------

API: nvim_set_option_value 

scope=nil                   :set              ALL
scope=global                :setglobal        ALL
scope=local                 :setlocal         ALL
scope=local, buf={bufnr}    :setlocal         local to buffer/global or local to buffer
scope=local, win={winid}    :setlocal         local to window/global or local to window


:set
  set wildignore=*.o,*.a,__pycache__
  vim.o.wildignore = '*.o,*.a,__pycache__'
  vim.opt.wildignore = { '*.o', '*.a', '__pycache__' }

:set+=
  vim.opt.wildignore:append { "*.pyc", "node_modules" }

:set^=
  vim.opt.wildignore:prepend { "new_first_value" }

:set-=
  vim.opt.wildignore:remove { "node_modules" }

Get:
  echo wildignore
  print(vim.o.wildignore)
  print(vim.opt.wildignore:get())






场景分析：
1. list 决定是否能显示 listchars
2. listchars 决定如何显示

1. list 是 local to window:
      1.不同 buffer list 的独立性
      2.相同 buffer 在不同的 window 中 list 的独立性：

      在特定窗口哪些 buffer 需要 list

2. listchars 是 global or local to window
      不同的 window 在同时编辑同一个 buffer，且 list 都为 true
      可以选择特定窗口显示 local value listchars，也可以选择特定窗口显示 global value listchars
--]]

vim.o.autowrite = false
vim.o.clipboard = "unnamedplus"
-- 如果在此毫秒数内没有键入任何内容，交换文件将被写入磁盘
vim.o.updatetime = 500
-- 在 TUI 中启用 24 位 RGB 颜色。
vim.o.termguicolors = true
-- 记住 ":" 命令的历史记录和以前的搜索模式的历史记录
vim.o.history = 500
-- 在屏幕的最后一行显示（部分）命令
vim.o.showcmd = true
vim.o.title = true
vim.o.titlestring = "MuHuiXueLuoAnPoQing"
vim.o.showmode = false

vim.go.cmdheight = 1
-- 在开始新行时（在插入模式下键入 <CR> 或使用 "o" 或 "O" 命令）从当前行 复制缩进
vim.go.autoindent = true
-- 启用自动 C 程序缩进
vim.go.cindent = true
-- 在开始新行时进行智能自动缩进
vim.go.smartindent = true
-- 当前窗口的最小列数
vim.o.winwidth = 2
vim.o.winaltkeys = "no"
vim.go.number = true
vim.go.relativenumber = true
-- 高亮显示其所有匹配项
vim.o.hlsearch = true
-- 在键入搜索命令时，显示到目前为止键入的模式匹配的位置
vim.o.incsearch = true
-- 在搜索模式、|cmdline-completion|、在标签文件中搜索、|expr-==| 以及插入模式补全 |ins-completion| 中忽略大小写
vim.o.ignorecase = true
-- 如果搜索模式包含大写字符，则覆盖 'ignorecase' 选项
vim.o.smartcase = true
vim.go.concealcursor = ""
vim.go.cursorline = false
vim.go.linebreak = false
vim.o.ruler = true
vim.go.conceallevel = 0
vim.go.list = true
vim.go.autoread = true
vim.go.signcolumn = "yes:2"
vim.o.laststatus = 3

vim.go.tabstop = 2
vim.go.softtabstop = 2
vim.go.shiftwidth = 2
vim.go.expandtab = true
vim.go.smarttab = true

vim.go.wrap = false
vim.go.showbreak = "󱞩 "
vim.go.scrolloff = 0
vim.go.swapfile = false
vim.o.backup = false
vim.go.undofile = true
vim.o.timeout = false

-- vim.o.pumheight = 8
vim.o.helplang = "cn"
vim.go.matchpairs = "(:),{:},[:],<:>,【:】,《:》,（:）,`:`"
vim.go.formatoptions = "jcroqql/"
vim.go.fillchars = "vert:│,horiz:─,fold: ,foldopen:,foldsep: ,foldclose:"
vim.go.virtualedit = "none"
vim.go.textwidth = 0
-- 设置分割窗口新窗口的位置
vim.o.splitbelow = true
vim.o.splitright = true
vim.go.listchars = "extends:⭆,tab:󰌥󰌒,trail:·"

require("option.fold")
require("option.tabline")
