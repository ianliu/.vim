" Vim Pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()

"{{{1 Global events
" Jump to the last cursor position
au BufReadPost *
\ if ! exists("g:leave_my_cursor_position_alone")   |
\   if line("'\"") > 0 && line ("'\"") <= line("$") |
\     exe "normal g'\""                             |
\   endif                                           |
\ endif
"}}}1

"{{{1 Commands
command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_
      \ | diffthis | wincmd p | diffthis
"}}}1

"{{{1 General Settings
set nocompatible            " We're running Vim, not Vi!
set laststatus=2            " always show the status line
set visualbell t_vb=        " No visual bell
set ai                      " auto indenting
set history=100             " keep 100 lines of history
set ruler                   " show the cursor position
set hidden                  " hide buffer without notice
set hlsearch                " highlight the last searched term
set showcmd                 " show number of lines selected
set incsearch               " incremental search
set t_Co=256                " terminal colors
set encoding=utf8           " uset UTF-8 by default
set bs=indent,eol,start     " better backspace in insert mode
set mouse=a                 " enable mouse
set grepprg=~/.vim/bin/ack\ --column " better grep!
set autowrite               " save buffers before some events
set makeprg=make\ -wj       " use more processors when making
set conceallevel=2          " hide conceals
set concealcursor=vin       " where should conceal work
set foldmethod=marker       " fold!
set pastetoggle=<F2>
let mapleader=","

" Default *.h files to "c" type
let g:c_syntax_for_h = 1

syntax on
filetype plugin indent on
"}}}1

"{{{1 Tag update methods
fun! UpdateCTags()
  !ctags `find . -name '*.[ch]'`
endf
"}}}1

"{{{1 File Types
if !exists("autocommands_loaded")
  let autocommands_loaded = 1

  " Scons
  au BufNewFile,BufRead SConstruct* setlocal filetype=python

  " Python
  au FileType python setlocal ts=4 sw=4 et sta
  au FileType python setlocal omnifunc=pythoncomplete#Complete
  au FileType python setlocal makeprg=pep8\ --repeat\ %

  " VIM
  au FileType vim setlocal ts=2 sw=2 et sta

  " HTML & XML
  au FileType html,xml setlocal ts=2 sw=2 et sta
  au FileType html,xml syn spell toplevel

  " vimprj
  au BufNewFile,BufRead *.vimprj setlocal syntax=vim

  " View man pages inside vim
  runtime ftplugin/man.vim

  " Java
  au FileType java setlocal ts=4 sw=4 et sta
  au FileType java setlocal omnifunc=javacomplete#Complete
endif
"}}}1

"{{{1 Devhelp Settings
function! DevhelpUpdate()
  call system('devhelp -a '.shellescape(expand('<cword>')).' &')
endfunction
au FileType c nnoremap <C-K> :call DevhelpUpdate()<CR>
"}}}1

"{{{1 MacVim & Gui Settings
if has("gui_macvim")
  " Set default GUI font
  set guifont=Menlo:h14

  let g:AutoPairsShortcutToggle     = 'π' " <m-p>
  let g:AutoPairsShortcutFastWrap   = '∑' " <m-w>
  let g:AutoPairsShortcutJump       = '∆' " <m-j>
  let g:AutoPairsShortcutBackInsert = '∫' " <m-b>

  " Start Full Screen
  set fuoptions=maxvert,maxhorz
  au GUIEnter * set fullscreen
endif

if has('gui_running')
  " Remove scroll bars
  set guioptions-=L
  set guioptions-=R
  set guioptions-=l
  set guioptions-=r

  " Disable toolbar
  set guioptions=-t
endif
"}}}1

"{{{1 Clang Complete Settings
let g:clang_auto_select=1
let g:clang_use_library=1
let g:clang_complete_macros=1
let g:clang_snippets=1
" let g:clang_snippets_engine='ultisnips'
" let g:clang_trailing_placeholder=1
" let g:clang_complete_copen=1
" let g:clang_memory_percent=70
" let g:clang_conceal_snippets=1
"}}}1

"{{{1 Color Scheme settings
colors default
if has("gui_running")
  set bg=light
else
  set bg=dark
endif
"}}}1

"{{{1 Key mappings
nnoremap Ç :
nnoremap ç ;
vnoremap Ç :
vnoremap ç ;

nnoremap <leader>e :e <C-R>=expand('%:h')<cr>/

nnoremap <F3> :cp<CR>
nnoremap <F4> :cn<CR>

nnoremap <C-G> :grep <C-R>=expand('<cword>')<CR>
nnoremap <S-F9> :call UpdateCTags()<CR>

nnoremap <F7> :make CC="~/.vim/bundle/clang_complete/bin/cc_args.py gcc"<CR>
nnoremap <F9> :make -C <C-R>=expand('%:h')<CR><CR>

" Toggle Shell Pasting
nnoremap <F2> :set invpaste paste?<cr>

noremap  <silent> <F6> :call g:ClangUpdateQuickFix()<cr>

nnoremap <S-K> :Man 2 <C-R>=expand('<cword>')<CR><CR>
"}}}1

"{{{1 vimprj configuration
call vimprj#init()
"}}}1
