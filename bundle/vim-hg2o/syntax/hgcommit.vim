" Vim syntax file
" Language: Mercurial commit file
" Maintainer:Ian Liu Rodrigues <ian.liu88@gmail.com>
" Last Revision: 10 Sep 2011

if exists("b:current_syntax")
  finish
endif

if has("spell")
  syn spell toplevel
endif

if exists("g:hg_commit_googlecode") && g:hg_commit_googlecode
  syn match hgCommitGCodeFixes "^\zs\(Fixes\|Resolves\|Closes\) issue\ze #\?\d\+$" nextgroup=hgCommitGCodeID contains=@NoSpell
  syn match hgCommitGCodeFixes "\zs\(Fixes\|Resolves\|Closes\) issue\ze #\?\d\+\." nextgroup=hgCommitGCodeID contains=@NoSpell
  syn match hgCommitGCodeFixes "(\zs\(Fixes\|Resolves\|Closes\) issue\ze #\?\d\+)" nextgroup=hgCommitGCodeID contains=@NoSpell
  syn match hgCommitGCodeFixes "(\zs\(Fixes\|Resolves\|Closes\) issue\ze #\?\d\+)" contained containedin=hgCommitSummary nextgroup=hgCommitGCodeID contains=@NoSpell
  syn match hgCommitGCodeFixes "\zs\(Fixes\|Resolves\|Closes\) issue\ze #\?\d\+\." contained containedin=hgCommitSummary nextgroup=hgCommitGCodeID contains=@NoSpell
  syn match hgCommitGCodeID    " #\?\d\+" contained contains=@NoSpell
  syn match hgCommitGCodeUp    "^\zsUpdate issue\ze #\?\d\+$" nextgroup=hgCommitGCodeUpID contains=@NoSpell
  syn match hgCommitGCodeUpID  " #\?\d\+$" nextgroup=hgCommitGCodeAttr skipnl
  syn match hgCommitGCodeExtra "^New \(issue\|review\)$" nextgroup=hgCommitGCodeAttr skipnl
  syn match hgCommitGCodeAttr  "^\zs\(Summary\|Status\|Owner\|Cc\|Labels\):\ze.*" nextgroup=hgCommitGCodeAttrV
  syn match hgCommitGCodeAttrV ".*" contained nextgroup=hgCommitGCodeAttr skipnl
  hi def link hgCommitGCodeFixes Special
  hi def link hgCommitGCodeID    Type
  hi def link hgCommitGCodeUp    Special
  hi def link hgCommitGCodeUpID  Type
  hi def link hgCommitGCodeExtra Special
  hi def link hgCommitGCodeAttr  PreProc
  hi def link hgCommitGCodeAttrV Special
endif

syn match hgCommitFirstLine "\%^\%(HG:\)\@!.\+" nextgroup=hgCommitBlank skipnl
syn match hgCommitSummary "^.\{0,65\}" contained containedin=hgCommitFirstLine nextgroup=hgCommitOverflow contains=@Spell
syn match hgCommitOverflow ".*" contained contains=@Spell
syn match hgCommitBlank "^\%(HG:\)\@!.\+" contained contains=@Spell

syn match hgCommitComment "^HG: .*" contains=hgCommitBranch,hgCommitAuthor,hgCommitFileMod,@NoSpell
syn match hgCommitAuthor  "^HG: user: \zs[^<]\+\ze.*" contained nextgroup=hgCommitEmail contains=@NoSpell
syn match hgCommitEmail   "<\zs[^>]\+\ze>" contained contains=@NoSpell
syn match hgCommitFileMod "^HG: \zs\(added\|changed\|removed\)\ze.*" contained nextgroup=hgCommitFile contains=@NoSpell
syn match hgCommitFile    " .*$" contained contains=@NoSpell
syn match hgCommitBranch  "^HG: branch '\zs[^']\+\ze'" contained contains=@NoSpell

let b:current_syntax = "hgcommit"

hi def link hgCommitAuthor   Define
hi def link hgCommitBranch   Special
hi def link hgCommitComment  Comment
hi def link hgCommitEmail    Underlined
hi def link hgCommitFile     Constant
hi def link hgCommitFileMod  Type
hi def link hgCommitSummary  Keyword
hi def link hgCommitBlank    Error
hi def link hgCommitOverflow Error
