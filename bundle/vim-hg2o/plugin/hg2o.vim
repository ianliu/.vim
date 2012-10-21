" hg2o.vim - Vim Hg2O is a wrapper for Mercurial version control system.
" Maintainer:  Ian Liu Rodrigues
" Version:     0.1

" Init {{{1
if exists('g:loaded_hg2o') || &cp
  finish
endif

let g:loaded_hg2o = 1
let s:HG = 'hg'
" }}}1
" Utils {{{1
fun! s:throw(msg)
  let v:errmsg = 'Hg2O: ' . a:msg
  throw v:errmsg
endf

" Returns the root dir of current buffer's HG repo
fun! s:root() abort
  if exists('b:hg_root') && b:hg_root !=# ''
    return b:hg_root
  endif
  let b:hg_root = system(s:HG . ' root')
  if v:shell_error == 0
    return b:hg_root
  endif
  call s:throw('not a mercurial repository: ' . expand('%:p'))
endf
" }}}1
" Hg {{{1
com! -nargs=? -complete=customlist,s:HgComplete Hg :execute s:Hg(<q-args>)

fun! s:Hg(cmd) abort
  exe '!' . s:HG . ' ' . a:cmd
endf

fun! s:HgComplete(A, L, P) abort
  let items = system(s:HG . ' debugcomplete '. a:A)
  if v:shell_error == 0
    return split(items, '\n')
  endif
endf
" }}}1
" Hgstatus {{{1
com! -nargs=0 Hgstatus :execute s:Hgstatus()

fun! s:CRStatus()
  let line = getline('.')
  if line =~# '^[MA] '
    wincmd p
    execute 'edit '.line[2:]
  endif
endf

fun! s:Hgstatus()
  pclose
  pedit hg2o://status
  wincmd P
  nnoremap <buffer> <silent> q    :<C-U>bdelete<CR>
  nnoremap <buffer> <silent> <CR> :<C-U>exe <SID>CRStatus()<CR>
  silent execute '0read !'.s:HG.' status'
  normal Gdd
  call cursor('1', '1')
  let nl = line('$') + 1
  if nl > 10
    let nl = 10
  endif
  execute 'res '.nl
  setlocal bufhidden=wipe nomodifiable nomodified readonly ft=hgstatus
endf
" }}}1
" Hgdiff {{{1
com! -nargs=0 Hgdiff :execute s:Hgdiff()

fun! s:Hgdiff()
  let ft = &ft
  let path = expand('%')
  let file = expand('%:t')
  let wnr = bufwinnr('%')
  let save_cursor = getpos('.')
  diffthis
  execute 'vnew hg2o://diff/'.file
  silent execute '0read !'.s:HG.' cat '.path
  normal Gdd
  execute 'setlocal ft='.ft
  setlocal bufhidden=wipe readonly nomodified nomodifiable
  diffthis
  wincmd p
  call setpos('.', save_cursor)
endf
" }}}1
" Hgblame {{{1
com! -nargs=0 Hgblame :execute s:Hgblame()

fun! s:Hgblame()
  let file = expand('%')
  only
  set scrollbind
  vnew IDs
  silent execute '0read !' . s:HG . ' blame ' . file . ''
  normal Gdd
  setlocal bufhidden=wipe readonly nomodified nomodifiable
  set scrollbind
endf
" }}}1
" Hgcommit {{{1
com! -nargs=0 Hgcommit :execute s:Hgcommit()

fun! s:Hgcommit()
endf
" }}}1
