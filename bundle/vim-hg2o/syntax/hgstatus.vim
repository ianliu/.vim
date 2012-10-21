" Vim syntax file
" Language: Mercurial commit file
" Maintainer:Ian Liu Rodrigues <ian.liu88@gmail.com>
" Last Revision: 13 Sep 2011

if exists("b:current_syntax")
  finish
endif

syn match hgStatusModified   "^M .*"
syn match hgStatusAdded      "^A .*"
syn match hgStatusRemoved    "^R .*"
syn match hgStatusClean      "^C .*"
syn match hgStatusMissing    "^! .*"
syn match hgStatusNotTracked "^? .*"
syn match hgStatusIgnored    "^I .*"

let b:current_syntax = "hgstatus"

hi def link hgStatusModified   Identifier
hi def link hgStatusAdded      Type
hi def link hgStatusRemoved    Statement
hi def link hgStatusClean      Preproc
hi def link hgStatusMissing    Error
hi def link hgStatusNotTracked Special
hi def link hgStatusIgnored    Ignore
