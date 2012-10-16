" Vim Pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#helptags()

syntax on
filetype plugin indent on

"{{{1 Global events
au InsertEnter * set nohls  " Disable highlighted search on insert mode
au InsertLeave * set hls    " Enable it back

" Jump to the last cursor position
au BufReadPost *
\ if ! exists("g:leave_my_cursor_position_alone")   |
\   if line("'\"") > 0 && line ("'\"") <= line("$") |
\     exe "normal g'\""                             |
\   endif                                           |
\ endif
"}}}1

"{{{1 General Settings
set nocompatible            " We're running Vim, not Vi!
set laststatus=2            " always show the status line
set noswapfile              " No swap files
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
set makeprg=make\ -j        " use more processors when making
set conceallevel=2          " hide conceals
set concealcursor=vin       " where should conceal work
set completeopt=menu,menuone " better completion!
set pastetoggle=<F2>
let mapleader=","

" Default *.h files to "c" type
let g:c_syntax_for_h = 1

" Smart tab completion
let g:SuperTabDefaultCompletionType="context"
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
  au BufNewFile,BufRead SConstruct* set filetype=python

  " Python
  au FileType python set ts=4 sw=4 et sta
  au FileType python set omnifunc=pythoncomplete#Complete
  au FileType python set makeprg=pep8\ --repeat\ %

  " VIM
  au FileType vim set ts=2 sw=2 et sta

  " HTML & XML
  au FileType html,xml set ts=2 sw=2 et sta
  au FileType html,xml syn spell toplevel

  " vimprj
  au BufNewFile,BufRead *.vimprj set syntax=vim
endif
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
" g:clang_user_options set at vimprj section
let g:clang_use_library=1
let g:clang_complete_copen=1
let g:clang_complete_macros=1
let g:clang_memory_percent=70
let g:clang_snippets=1
let g:clang_conceal_snippets=1
let g:clang_snippets_engine='ultisnips'
"}}}1

"{{{1 Color Scheme settings
let g:zenburn_old_Visual=1
let g:zenburn_high_Contrast=1
let g:zenburn_alternate_Visual=1

if has('gui_running')
    colors vilight
else
    colors zenburn
endif
"}}}1

"{{{1 Key mappings
nnoremap ç :
nnoremap Ç ;
nnoremap : ;
nnoremap ; :
vnoremap ç :
vnoremap ; :

nnoremap <leader>e :e <C-R>=expand('%:h')<cr>/

nnoremap <F3> :cp<CR>
nnoremap <F4> :cn<CR>

nnoremap <C-G> :grep <C-R>=expand('<cword>')<CR>
nnoremap <S-F10> :call UpdateCTags()<CR>

nnoremap <F10> :make -C <C-R>=expand('%:h')<CR>

" Toggle Shell Pasting
nnoremap <F2> :set invpaste paste?<cr>

noremap  <silent> <F6> :call g:ClangUpdateQuickFix()<cr>
noremap  <silent> <F9> :SCCompileRun<cr>

" bufkill bd's: really do not mess with NERDTree buffer
nnoremap <silent> <backspace> :BD<cr>
nnoremap <silent> <s-backspace> :BD!<cr>

" Map NERDTreeToggle to convenient key
nnoremap <silent> <c-n> :NERDTreeToggle<cr>
"}}}1

"{{{1 NERDTree settings
" Prevent :bd inside NERDTree buffer
au FileType nerdtree cnoreabbrev <buffer> bd <nop>
au FileType nerdtree cnoreabbrev <buffer> BD <nop>
let NERDTreeChDirMode=2
let NERDTreeIgnore=['\env','\.vim$', '\~$', '\.pyc$', '\.swp$', '\.egg-info$', '\.DS_Store$', '^dist$', '^build$']
let NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$', '\~$']
let NERDTreeShowBookmarks=1
let NERDTreeHightlightCursorline=1
" }}}1

"{{{1 vimprj configuration
call vimprj#init()
"}}}1
