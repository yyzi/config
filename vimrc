" 常规设置（编辑与外观）--------------------------{{{

" 设置行高亮、颜色
set t_Co=256 
set cursorline
hi CursorLine ctermbg=237 guibg=#3a3a3a cterm=none gui=none 
hi  Comment  ctermfg=darkgrey

" 不兼容 vi
set nocompatible

" 用空格代替 TAB
set expandtab

" 整体左移或者右移时，每次 4 个空格
set shiftwidth=4

" TAB 键按 4 空格对齐
set tabstop=4

" 光标移动到 buffer 的顶部和底部时保持 5 行距离
set scrolloff=5

" 文件写入成功后，不保留备份文件
set nobackup

" 直接写原文件，不先建立备份
set nowritebackup

" 不要交换文件
set noswapfile

"" C 语法格式的自动缩进
"set cindent
"
"" 据说比 cindent 还好用。
"set smartindent
"
"" 自动缩进
"set autoindent

" 在状态栏显示正在输入的命令
set showcmd

" c 指令（change）时，末尾显示 $ 符号
set cpoptions+=$

" 光标移动距离屏幕顶部或底部 5 行时，开始滚动
set scrolloff=5

" 打开命令行补全菜单（出现在状态栏上）
set wildmenu

" 总是显示 ruler 行。
set ruler

" 命令行高度
set cmdheight=1

" 用退格键可以删除自动缩进、换行符、越过编辑起始点
set backspace=indent,eol,start

" 出错时不出声
set noerrorbells
set novisualbell

" 关闭高亮显示配对括号
" let loaded_matchparen = 1

" 仅在 Normal 模式和 Visual 模式下才可以用鼠标
" 这意味着要想用鼠标复制到剪切板的话，只需要按
" i 进入插入模式，或者按 : 进入命令行模式就可以了。
set mouse=nv

" 编码设置 "
set encoding=utf-8
"set encoding=chinese
set fileencodings=utf-8,ucs-bom,utf-16le,gbk,big5,euc-jp

" 搜索关键字高亮
set hlsearch

" 在搜索时，输入的词句的逐字符高亮（类似firefox的搜索）
set incsearch
hi Search term=standout ctermfg=0 ctermbg=3

" 显示行号
set number

" 只有当存在多个标签页时，才显示标签行。
set showtabline=1

"}}}

setlocal foldlevel=1

" 不用 vim 自动添加粘贴文字的缩进
set paste

autocmd BufNewFile *.sh,*.pl,*.py exec ":call SetTitle()"

" go 程序自动使用 go fmt 格式化
au FileType go au BufWritePre <buffer> Fmt

" plugin
" ==============================================================================
    " plugin
    set nocompatible              " be iMproved, required
    filetype off                  " required

    " set the runtime path to include Vundle and initialize
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
    " alternatively, pass a path where Vundle should install plugins
    "call vundle#begin('~/some/path/here')

    " let Vundle manage Vundle, required
    Plugin 'gmarik/Vundle.vim'

    " The following are examples of different formats supported.
    " Keep Plugin commands between vundle#begin/end.
    " plugin on GitHub repo
    Plugin 'tpope/vim-fugitive'
    " plugin from http://vim-scripts.org/vim/scripts.html
    Plugin 'L9'
    " Git plugin not hosted on GitHub
    Plugin 'git://git.wincent.com/command-t.git'
    " git repos on your local machine (i.e. when working on your own plugin)
    " Plugin 'file:///home/gmarik/path/to/plugin'
    " The sparkup vim script is in a subdirectory of this repo called vim.
    " Pass the path to set the runtimepath properly.
    Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
    " Avoid a name conflict with L9
    " Plugin 'user/L9', {'name': 'newL9'}

    " markdown
    Plugin 'tpope/vim-markdown'

    " golang
    Plugin 'jnwhiteh/vim-golang'

    " js
    "Plugin 'pangloss/vim-javascript'
    Plugin 'lukaszb/vim-web-indent'

    "nodejs
    Plugin 'ahayman/vim-nodejs-complete'

    "css
    "Plugin 'hail2u/vim-css3-syntax'

    " python
    Plugin 'klen/python-mode'

    " pydoc
    "Plugin 'fs111/pydoc.vim'

    "perl
    Plugin 'vim-perl/vim-perl'

    "shell
    Plugin 'Shougo/vimshell.vim'

    "php
    "Plugin 'StanAngeloff/php.vim'

    "html
    Plugin 'othree/html5.vim'

    "json
    Plugin 'elzr/vim-json'

    "yaml
    Plugin 'avakhov/vim-yaml'

    "wordpress
    "Plugin 'dsawardekar/wordpress.vim'

    " taglist
    Plugin 'taglist.vim'

    " A tree explorer plugin for vim.
    Plugin 'scrooloose/nerdtree'

    " tagbar  侧边栏
    Plugin 'majutsushi/tagbar'

    " vim-airline  只能状态栏
    Plugin 'bling/vim-airline'

    " 智能注释
    Plugin 'tpope/vim-commentary'

    " git diff
    Plugin 'airblade/vim-gitgutter'

    " go 自动补全
    Plugin 'ervandew/supertab'

    " 在文件中搜索
    Plugin 'mileszs/ack.vim'

    " All of your Plugins must be added before the following line
    call vundle#end()            " required
    filetype plugin indent on    " required
    " To ignore plugin indent changes, instead use:
    "filetype plugin on
    "
    " Brief help
    " :PluginList          - list configured plugins
    " :PluginInstall(!)    - install (update) plugins
    " :PluginSearch(!) foo - search (or refresh cache first) for foo
    " :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
    "
    " see :h vundle for more details or wiki for FAQ
    " Put your non-Plugin stuff after this line



" plugin setting
" =====================================================================================

" vim-airline 配置
    " 默认显示状态栏
    set laststatus=2
    " 开启tabline
    let g:airline#extensions#tabline#enabled = 1
    " tabline中当前buffer两端的分隔字符
    let g:airline#extensions#tabline#left_sep = ' '
    " tabline中未激活buffer两端的分隔字符
    let g:airline#extensions#tabline#left_alt_sep = '|'
    " tabline中buffer显示编号
    "let g:airline#extensions#tabline#buffer_nr_show = 1
    " 显示时间
    let g:airline_section_b = '%{strftime("%y-%m-%d %H:%M:%S")}'

" tagbar 在左侧显示
    let g:tagbar_left = 1



" 文件树
    "打开/关闭 树状文件目录  
    map <F3> :NERDTreeToggle<CR>  
    " 右侧显示文件树
    let NERDTreeWinPos="right"

"nmap <F5> :Tlist<CR>
nmap <F5> :TagbarToggle<CR>

" 显示 git diff
nmap <F8> :GitGutterToggle<CR>

" 默认不显示 git diff 当按 f8 以后才显示 diff 并且变更行高亮
let g:gitgutter_enabled = 0
let g:gitgutter_highlight_lines = 1


" git diff 左侧侧边栏背景色
highlight SignColumn ctermbg=237

" git diff change 行高亮
    highlight GitGutterAddLine      ctermbg=240 ctermfg=2
    highlight GitGutterDeleteLine   ctermbg=240 ctermfg=198
    highlight GitGutterChangeLine   ctermbg=240 ctermfg=11
    let g:gitgutter_eager=1
    let g:gitgutter_realtime=1

" supertab 自动补全的按键绑定
 let g:SuperTabDefaultCompletionType = "<c-n>"



" functions
" =====================================================================================
func SetTitle()
        if &filetype == 'sh'
                call setline(1, "\#!/bin/sh")
                call append(line("."), "\#****************************************************************#")
                call append(line(".")+3, "\# Create Date: ".strftime("%F %R"))
                call append(line(".")+7, "\#***************************************************************#")
                call append(line(".")+8, "")
                :8
        elseif &filetype == 'perl'
                call setline(1, "\#!/usr/bin/perl")
                call append(line("."), "\#****************************************************************#")
                call append(line(".")+3, "\# Create Date: ".strftime("%F %R"))
                call append(line(".")+7, "\#***************************************************************#")
                call append(line(".")+8, "")
                :8
        elseif &filetype == 'python'
                call setline(1, "\#!/usr/bin/python")
                call append(line("."), "\# -*- coding: utf-8 -*-")
                call append(line(".")+1, "\#****************************************************************#")
                call append(line(".")+4, "\# Create Date: ".strftime("%F %R"))
                call append(line(".")+8, "\#***************************************************************#")
                call append(line(".")+9, "")
                :8
        endif
endfunc


" gotags 
let g:tagbar_type_go = {
    \ 'ctagstype' : 'go',
    \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
    \ ],
    \ 'sro' : '.',
    \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
    \ },
    \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
    \ },
    \ 'ctagsbin'  : 'gotags',
    \ 'ctagsargs' : '-sort -silent'
\ }
