" Vim Pathogen 
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()

" General Settings
"set expandtab
"set tabstop=4
"set shiftwidth=4
"set softtabstop=4
set laststatus=2            " always show the status line
set nocompatible            " We're running Vim, not Vi!
set noswapfile              " No swap files
set visualbell t_vb=        " No visual bell
set ai                      " auto indenting
set history=100             " keep 100 lines of history
set ruler                   " show the cursor position
set hidden                  " hide buffer without notice
set hlsearch                " highlight the last searched term
"set virtualedit=all         " let us walk in limbo
set showcmd                 " show number of lines selected
set incsearch               " incremental search
set t_Co=256                " terminal colors
set encoding=utf8           " uset UTF-8 by default
set bs=indent,eol,start     " better backspace in insert mode
set mouse=a                 " enable mouse
set grepprg=~/.vim/bin/ack\ --column " better grep!
set autowrite               " save buffers before some events
set makeprg=make\ -j        " use more processors when making
syntax on                   " syntax highlighting
filetype plugin indent on   " use the file type plugins
au InsertEnter * :let @/="" " Disable highlighted search on insert mode
au InsertLeave * :let @/="" " Enable it back

nnoremap ç :
nnoremap Ç ;
nnoremap : ;
nnoremap ; :
vnoremap ç :
vnoremap ; :

nnoremap <F3> :cp<CR>
nnoremap <F4> :cn<CR>

nnoremap <C-G> :grep <C-R>=expand('<cword>')<CR>
nnoremap <S-F10> :call UpdateCTags()<CR>

nnoremap <F10> :make -C <C-R>=expand('%:h')<CR>

fun! UpdateCTags()
  !ctags `find . -name '*.[ch]'`
endf

" Smart tab completion
au BufNewFile,BufRead * let g:SuperTabDefaultCompletionType="context"

let mapleader=","
nnoremap <leader>e :e <C-R>=expand('%:h')<cr>/

" When editing a file, always jump to the last cursor position
au BufReadPost *
\ if ! exists("g:leave_my_cursor_position_alone")   |
\   if line("'\"") > 0 && line ("'\"") <= line("$") |
\     exe "normal g'\""                             |
\   endif                                           |
\ endif

" File Types

" Scons
au BufNewFile,BufRead SConstruct* set filetype=python

" Python
au FileType python set ts=4 sw=4 et sta
au FileType python set omnifunc=pythoncomplete#Complete
au FileType python set makeprg=pep8\ --repeat\ %

" HTML & XML
au FileType html,xml set ts=2 sw=2 et sta
au FileType html,xml syn spell toplevel

" C++
au FileType c,cpp,objc,objcpp set syntax=cpp11 | call CSyntaxAfter()
au BufNewFile,BufRead *
\ if expand('%:e') =~ '^\(h\|hh\|hxx\|hpp\|ii\|ixx\|ipp\|inl\|txx\|tpp\|tpl\|cc\|cxx\|cpp\)$' |
\   if &ft != 'cpp'                                                                           |
\     set ft=cpp                                                                              |
\   endif                                                                                     |
\ endif

" vimprj
au BufNewFile,BufRead *.vimprj set syntax=vim

" MacVim Settings

if has("gui_macvim")
  " Set default GUI font
  set guifont=Menlo:h14

  let g:AutoPairsShortcutToggle     = 'π' " <m-p>
  let g:AutoPairsShortcutFastWrap   = '∑' " <m-w>
  let g:AutoPairsShortcutJump       = '∆' " <m-j>
  let g:AutoPairsShortcutBackInsert = '∫' " <m-b>
endif

if has('gui_running')
  " Remove scroll bars
  set guioptions-=L
  set guioptions-=R
  set guioptions-=l
  set guioptions-=r

  " Disable toolbar
  set guioptions=-t

  " Start Full Screen
  set fuoptions=maxvert,maxhorz
  au GUIEnter * set fullscreen
endif

" Clang Complete Settings
" g:clang_user_options set at vimprj section
let g:clang_use_library=1
let g:clang_complete_copen=1
let g:clang_complete_macros=1
let g:clang_complete_patterns=0
" Avoids lame path cache generation and other unknown sources for includes 
let g:clang_auto_user_options=''
let g:clang_memory_percent=70

set conceallevel=2
set concealcursor=vin
let g:clang_snippets=1
let g:clang_conceal_snippets=1
" The single one that works with clang_complete
let g:clang_snippets_engine='clang_complete'

" Complete options (disable preview scratch window, longest removed to aways
" show menu)
set completeopt=menu,menuone

" Limit popup menu height
set pumheight=20

" SuperTab completion fall-back 
let g:SuperTabDefaultCompletionType='<c-x><c-u><c-p>'

" SuperTab completion fall-back for context aware completion
" (incompatible with g:clang_auto_select=0, using the above)
" let g:SuperTabContextDefaultCompletionType='<c-x><c-u><c-p>'

" Reparse the current translation unit in background
command Parse
\ if &ft == 'c' || &ft == 'cpp'   |
\   call g:ClangBackgroundParse() |
\ else                            |
\   echom 'Parse What?'           |
\ endif

" Reparse the current translation unit and check for errors
command ClangCheck
\ if &ft == 'c' || &ft == 'cpp'   |
\   call g:ClangUpdateQuickFix()  |
\ else                            |
\   echom 'Check What?'           |
\ endif

" Color Scheme
let g:zenburn_old_Visual=1
let g:zenburn_high_Contrast=1
let g:zenburn_alternate_Visual=1

if has('gui_running')
    colors vilight
else
    colors zenburn
endif

" Set the most common used run command
if has('win32') || has('win64') || has('os2')
    let g:common_run_command='$(FILE_TITLE)$'
else
    let g:common_run_command='./$(FILE_TITLE)$'
endif

" SingleCompile for C++ with Clang
function! <SID>LoadSingleCompileOptions()
    call SingleCompile#SetCompilerTemplate('c', 
                \'clang', 
                \'the Clang C and Objective-C compiler', 
                \'clang', 
                \'-o $(FILE_TITLE)$ ' . g:single_compile_options, 
                \g:common_run_command)

    call SingleCompile#ChooseCompiler('c', 'clang')

    call SingleCompile#SetCompilerTemplate('cpp', 
                \'clang', 
                \'the Clang C and Objective-C compiler', 
                \'clang++', 
                \'-o $(FILE_TITLE)$ ' . g:single_compile_options, 
                \g:common_run_command)

    call SingleCompile#ChooseCompiler('cpp', 'clang')
endfunction

" Key mappings

" Toggle Shell Pasting
nnoremap <F2> :set invpaste paste?<cr>
set pastetoggle=<F2>

noremap  <silent> <F5> :Parse<cr>
noremap  <silent> <F6> :ClangCheck<cr>
noremap  <silent> <F7> :SCCompile<cr>
noremap  <silent> <F9> :SCCompileRun<cr>
noremap! <silent> <F5> <c-o>:Parse<cr>
noremap! <silent> <F6> <c-o>:ClangCheck<cr>
noremap! <silent> <F7> <c-o>:SCCompile<cr>
noremap! <silent> <F9> <c-o>:SCCompileRun<cr>

nnoremap <silent> <s-up>    :wincmd k<cr>
nnoremap <silent> <s-down>  :wincmd j<cr>
nnoremap <silent> <s-left>  :wincmd h<cr>
nnoremap <silent> <s-right> :wincmd l<cr>

" bufkill bd's: really do not mess with NERDTree buffer
nnoremap <silent> <backspace> :BD<cr>
nnoremap <silent> <s-backspace> :BD!<cr>

" Map NERDTreeToggle to convenient key
nnoremap <silent> <c-n> :NERDTreeToggle<cr>

" Map <m-d> to <c-x><c-f> file name completion in MacVim
if has("gui_macvim")
  noremap! ∂ <c-x><c-f>
endif

" Prevent :bd inside NERDTree buffer
au FileType nerdtree cnoreabbrev <buffer> bd <nop>
au FileType nerdtree cnoreabbrev <buffer> BD <nop>

" NERDTree settings
let NERDTreeChDirMode=2
let NERDTreeIgnore=['\env','\.vim$', '\~$', '\.pyc$', '\.swp$', '\.egg-info$', '\.DS_Store$', '^dist$', '^build$']
let NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\~$']
let NERDTreeShowBookmarks=1
let NERDTreeHightlightCursorline=1

" CommandT mappings (ƒ = <m-f>)
nnoremap <silent> ƒ       :CommandT<cr>
nnoremap <silent> <space> :CommandTBuffer<cr>

" vimprj configuration

" Initialize vimprj plugin
call vimprj#init()

" vimprj hooks

" Called BEFORE sourcing .vimprj and when not sourcing
function! g:vimprj#dHooks['SetDefaultOptions']['main_options'](dParams)
    let g:vimprj_dir = substitute(a:dParams['sVimprjDirName'], '[/\\]\.vimprj$', '', '')
    
    let g:clang_user_options = ''
    if &ft == 'cpp'
        let g:clang_user_options = '-std=c++11 -stdlib=libc++'
    endif

    let g:single_compile_options = '-O3 ' . g:clang_user_options
endfunction

" Called AFTER sourcing .vimprj and when not sourcing
function! g:vimprj#dHooks['OnAfterSourcingVimprj']['main_options'](dParams)
    unlet g:vimprj_dir
    call <SID>LoadSingleCompileOptions()
endfunction
