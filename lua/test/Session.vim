let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/AppData/Local/nvim/lua/test
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +12 ~/AppData/Local/nvim/init.lua
badd +79 ~/AppData/Local/nvim/lua/test/init.lua
badd +202 ~/AppData/Local/nvim-data/lazy/neodev.nvim/types/stable/api.lua
argglobal
%argdel
edit ~/AppData/Local/nvim/lua/test/init.lua
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd w
wincmd _ | wincmd |
split
1wincmd k
wincmd w
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe 'vert 1resize ' . ((&columns * 1 + 64) / 128)
exe '2resize ' . ((&lines * 28 + 16) / 32)
exe 'vert 2resize ' . ((&columns * 126 + 64) / 128)
exe '3resize ' . ((&lines * 1 + 16) / 32)
exe 'vert 3resize ' . ((&columns * 126 + 64) / 128)
tcd ~/AppData/Local/nvim/lua/test
argglobal
enew
file ~/AppData/Local/nvim/neo-tree\ filesystem\ [1]
setlocal fdm=indent
setlocal fde=nvim_treesitter#foldexpr()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
wincmd w
argglobal
balt ~/AppData/Local/nvim-data/lazy/neodev.nvim/types/stable/api.lua
setlocal fdm=manual
setlocal fde=nvim_treesitter#foldexpr()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal fen
silent! normal! zE
5,9fold
15,16fold
13,17fold
19,20fold
21,22fold
18,23fold
12,24fold
27,28fold
37,40fold
44,47fold
49,52fold
55,58fold
34,69fold
72,73fold
79,82fold
78,83fold
76,84fold
87,89fold
let &fdl = &fdl
76
normal! zo
78
normal! zo
let s:l = 79 - ((14 * winheight(0) + 14) / 28)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 79
normal! 049|
wincmd w
argglobal
enew | setl bt=help
help api-buffer-updates-lua@en
setlocal fdm=manual
setlocal fde=nvim_treesitter#foldexpr()
setlocal fmr={{{,}}}
setlocal fdi=#
setlocal fdl=99
setlocal fml=1
setlocal fdn=20
setlocal nofen
silent! normal! zE
let &fdl = &fdl
let s:l = 387 - ((0 * winheight(0) + 0) / 1)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 387
normal! 0
wincmd w
2wincmd w
exe 'vert 1resize ' . ((&columns * 1 + 64) / 128)
exe '2resize ' . ((&lines * 28 + 16) / 32)
exe 'vert 2resize ' . ((&columns * 126 + 64) / 128)
exe '3resize ' . ((&lines * 1 + 16) / 32)
exe 'vert 3resize ' . ((&columns * 126 + 64) / 128)
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=25
let &shortmess = s:shortmess_save
let &winminheight = s:save_winminheight
let &winminwidth = s:save_winminwidth
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
