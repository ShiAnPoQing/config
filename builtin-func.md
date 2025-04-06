获取api info vim.fn.api_info()
当前缓冲区指定行追加文本行 append(lnum: number, text: string|string[]): 0|1
指定缓冲区指定行追加文本行 appendbufline(buf: ID, lnum: number, text: string | string[]): 0|1
获取指定缓冲区的文件数 argc(winid?: integer): number
argidx()
arglist
arglistid()
argv
断言视觉铃声 assert_beeps(cmd: string): 0|1
断言是否相等 assert_equal 
断言文件是否相等 assert_equalfile(fname_one, fname_two): 0|1
断言异常： assert_exception(error: any, msg?:any): 0|1
断言失败： assert_fails
断言false: assert_false(actual [, {msg}]): 0|1
断言true:  assert_true
断言范围： assert_inrange
断言匹配： assert_match
断言无蜂鸣：assert_nobeep(cmd: string): 0|1
断言不相等：assert_notequal
断言不匹配：assert_notmatch
断言报告： assert_report(msg: string): 0|1
Blob每个字节的数值的列表：blob2list(blob: any): any[]
设置文件请求器：browse
browserid()
新增缓冲区：bufadd(name: string): 0|1
缓冲区存在：bufexists(buf: any): 0|1
获取缓冲区列表：buflisted({buf}): 0|1
缓冲区加载：bufload({buf})
获取缓冲区名称：bufname
获取缓冲区号：bufnr
获取缓冲区win-id: bufwinid()
获取缓冲区win-编号：bufwinnr(buf)
返回当前缓冲区中指定字节数的行号：byte2line(byte)
返回字符串中第n个字符：byteidx byteidxcomp
调用函数：call(func, arglist [, dict]): any
返回最近更改的标号（撤销）：changenr()
返回字符串第一个字符的数值：char2nr(string[, utf8]) charclass
返回给定col位置的字符索引不是字节位置 charcol(expr [, winid])
结果是一个数字，即用 {expr} 给出的列位置的字节索引 col(expr[, winid]): number
返回字符串中idx处字节的字符索引：charidx
更改当前工作目录：chdir(dir): string
获取指定行的缩进量：cindent(lnum)
清除先前通过 matchadd() 和 :match 命令为当前窗口定义的所有匹配项。: clearmatches([{win}])
设置插入模式完成的匹配项： complete
添加expr到匹配列表：complete_add
完成检查：complete_check
完成info: complete_info
confirm对话框： confirm
复制: copy(expr)
返回字符串、列表或字典中某个值出现的次数： count
ctxget()
ctxpop()
ctxpush()
ctxsize()
设置光标位置 cursor(lnum, col[, off]) | cursor(list)
深拷贝：deepcopy
删除文件：delete(fname[, flags])
删除缓冲区行：deletebufline(buf, first[, last])
字典监听器：dictwatcheradd
删除字典监听器：dictwatcherdel
避免FileType事件多次触发: did_filetype()
差异填充：diff_filler()
diff_hlID
返回二和字母：digraph_get
digraph_getlist()
digraph_set
digraph_setlist
判断是否为空： empty(expr)
has_key
转义：escape
计算string并返回结果：eval(string)
eventhandler()
executable({expr})
执行命令：execute
返回可执行文件的完整路径：exepath
存在：exists
扩展：*expand
扩展命令：expandcmd
echo expandcm("mak %<.o")
make/path/runtime/doc/builtin.o
延长列表：extend
echo sort(extend(mylist, [7, 5]))
call extend(mylist, [2, 3], 1)
extendnew()
*feedkeys
文件复制：filecopy
文件可读：filereadable
文件可写：filewritable
过滤： filter
查找目录：finddir
查找文件：findfile
扁平化：flatten
flattennew
浮点数：float2nr
转义文件名称：fnameescape
修改文件名：fnamemodify
关闭折叠：foldclosed
折叠结束：foldclosedend
折叠级别：foldlevel
折叠文本：foldtext
返回折叠文本结果：foldtextresult
完成命令：fullcommand
函数引用：funcref
获取get
获取缓冲区信息：getbufinfo
获取缓冲区行：getbufline
getbufoneline

getbufvar
获取单元格宽度：getcellwidths
获取字符 getchangelist
获取字符 getchar
获取字符mod值：getcharmod()
获取字符位置：getcharpos
获取字符搜索：getcharsearch
获取字符字符串：getcharstr
获取命令执行结果：getcmdcomplpat
获取命令完成类型：getcmdcompltype
获取命令行：getcmdline
获取命令行光标位置：getcmdpos
获取命令行光标的屏幕位置：getcmdscreenpos
获取命令提示符：getcmdprompt
获取命令类型：getcmdtype
获取当前命令行窗口类型：getcmdwintype
获取命令行完成匹配的列表：getcompletion
获取光标位置：getcurpos getcursorcharpos
获取当前工作目录：getcwd
获取环境变量： getenv
获取字体名称：getfontname
获取权限：getfperm
获取文件大小：getfsize
获取时间getftime
获取文件类型：getftype
获取跳转列表：getjumplist
获取行：getline
获取本地位置列表：getloclist
获取标记列表：getmarklist
获取匹配项：getmatches
获取鼠标位置：getmousepos
