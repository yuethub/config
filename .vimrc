" 基本设置{{{
set nocompatible
filetype plugin on
filetype plugin indent on
set encoding=utf-8
set nu
set hlsearch
set autoindent
set tabstop=4
set softtabstop=4
set expandtab
set shiftwidth=4
set bg=dark
set ruler
set backspace=2 
"}}}


" 折叠设置{{{
set foldmethod=marker
noremap z{ zfa{
"}}}


" 查找设置{{{
set ignorecase                  " 搜索是忽略大小写
set smartcase                   " 智能判断是否大小写，该选项在ignorecase打开的情况下生效
set incsearch                   " 预览匹配项
" 取消高亮显示
noremap <C-j> :nohl<CR>
"}}}


" 补全设置{{{
set completeopt=menu,menuone
let OmniCpp_NamespaceSearch = 2 
let OmniCpp_DisplayMode = 1
let OmniCpp_DefaultNamespaces = ["std"]  
let OmniCpp_ShowPrototypeInAbbr = 1 
let OmniCpp_SelectFirstItem = 2 
let OmniCpp_MayCompleteScope = 1

set tags+=~/tags/stdcpp                     " 添加tags文件
set tags+=~/tags/qt                         " 添加tags文件
set dictionary+=~/.vim/dict/cpp.list                  " 添加字典文件

" 全能补全重映射
inoremap <C-o> <C-x><C-o>
" 行补全重映射
inoremap <C-l> <C-x><C-l>
" 字典补全重映射
inoremap <C-k> <C-x><C-k>
" 文件名补全重映射
inoremap <C-f> <C-x><C-f>
" tags补全重映射
inoremap <C-]> <C-x><C-]>
" 在当前目录下创建tags文件
noremap <F5> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
"}}}

" 语法高亮设置{{{
syntax on
"}}}

" 移动 {{{
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>

cnoremap <C-h> <Left>
cnoremap <C-l> <Right>
"}}}

" 文件及窗口管理{{{
" 在屏幕左侧打开当前目录
noremap <C-l> :Lexplore<CR>20<C-w><Bar>
" 使用 "%%" 代替 ": %:hTAB": 来补全当前缓冲区文件的路径
cnoremap <expr> %% getcmdtype( ) == ':' ? expand('%:h').'/' : '%%'
"}}}

" 拼写检查{{{
set spell   " 关闭拼写检查
set spelllang=en    " 设置拼写检查语言
set spellfile=~/.vim/spell/en.utf-8.add
"}}}









" 使用vim-plug插件管理器
"call plug#begin()
"call plug#end()


" GVIM设置
"set lines=33 columns=125
"set guifont=Consolas:h18:cANSI:qDRAFT

" 设置工作目录
" cd E:\Ctags_Ws\
