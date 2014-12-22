:au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif
syntax on
set enc=utf-8
set laststatus=2
set tags=/www/test3/tags;
set autochdir
set tabstop=4
set softtabstop=4
set shiftwidth=4
set autoindent
set smartindent
set wrap
"禁止生成临时文件
set nobackup
set noswapfile
"set cindent
set nu
set hlsearch
"行号
hi linenr ctermfg=darkgray
hi cursor ctermfg=blue
hi title guifg=gray
hi normal guifg=gray
"注释
hi comment ctermfg=darkgray 
hi keyword ctermfg=red
"字符串
hi string ctermfg=darkgray
"函数
hi function ctermfg=cyan
"预处理
hi todo ctermfg=gray
"系统常量, __FILE__...
hi constant ctermfg=cyan
"特殊字符
hi special ctermfg=white
"echo...
hi preproc ctermfg=magenta
"条件表达式
hi statement ctermfg=magenta
"php的self、->
hi type ctermfg=magenta
"状态栏
hi StatusLine	guifg=darkblue guibg=darkgray gui=none		ctermfg=black ctermbg=darkgray term=none cterm=none
"colorscheme darkblue

"php函数提示
au FileType php call PHPFuncList()
function PHPFuncList()
set dictionary-=~/.vim/php_funclist.txt
set dictionary+=~/.vim/php_funclist.txt
set complete-=k complete+=k
endfunction

"代码提示背景
hi Pmenu guifg=black guibg=darkgray ctermfg=darkgreen ctermbg=black

"目录树
nnoremap <silent> <F5> :NERDTree<CR>

"ctags
set tags+=/study/php-src/tags

set completeopt=longest,menu 

filetype plugin indent on
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags noci
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#Complete

" 在 vim 启动的时候默认开启 NERDTree（autocmd 可以缩写为 au）
autocmd VimEnter * NERDTree

" 当打开 NERDTree 窗口时，自动显示 Bookmarks
let NERDTreeShowBookmarks=1

if has("autocmd") && exists("+omnifunc")
autocmd Filetype *
\ if &omnifunc == "" |
\ setlocal omnifunc=syntaxcomplete#Complete |
\ endif
endif

"if has("gui_running") 
"	highlight SpellBad term=underline gui=undercurl guisp=Orange 
"endif 


:set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]
