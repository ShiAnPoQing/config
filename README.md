# Neovim Config(仅供参考)

1. 给予 vim 的全新的理念:
   1. vim 核心应当遵循: `user input → execute command`
      1. 操作的原子应当是一个 `command`，即任何 `user input` 最终都应该是一个 `<Cmd>`
         1. 推论1：在所有 `mode` 都应当可以手动执行一个`command`，
            因此应当存在一个映射可以直接进入 `command mode`，
            内置：`<C-o>` 可以满足推论，但不合理
            ```
            api: my.input_command

            normal mode           → <S-;>             my.input_command()
            operator pending mode → <S-;>             my.input_command()
            visual mode           → <S-;>[<C-u>]      my.input_command()
            select mode           → <C-S-;>           my.input_command()
            insert mode           → <C-S-;>           my.input_command()
            ```
   1. 映射应当仅是 `command` 的触发器，而不应当是 `command` 本身
      1. 内置映射不满足此要求:\
         比如: `移动到行尾`(`cursor.set.current_line_last_character`)\
         vim 只有 `$`，而没有该 `command`\
         用户不得不： `feedkeys('$', 'n')`、或 `normal! $`
   1. 映射应当遵循 **人体工学**, 而不是仅仅是英文含义\
      比如: `$` 和 `0`\
      一个对称的左右 `motion`， 但按键位置极其不对称，而且 `$ == <S-4>`

## Command

### window set cursor

`nvim_win_set_cursor`

```
window set cursor: nvim_win_set_cursor
    1.current window
      1. set cursor
      2. motion
    2.other window
```

```
my.win.cursor.set
my.win[0].cursor.set
my.win[0].cursor.motion
my.win[win].cursor.set
```

## Mapping

### Mapping sequence

#### Interrupt mapping sequence

> 通过某个映射中断当前映射序列

内置映射：`:h CTRL-C` `:h <Esc>`

问题：

1. `<C-c>` 烦人的消息\
   解决方案：`<cmd>silent normal! \\<C-c><Cr>`
1. 在可视模式下 `<C-c>` 或 `<Esc>` 都会退出可视模式(即使本意是要中断当前映射)

重新设计 `<esc>`：

1. 处于未完成的映射序列中，`<esc>` 应当中断当前映射
1. `fallback`
