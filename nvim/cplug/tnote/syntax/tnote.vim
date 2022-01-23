" Left indent definitions
"syn clear
syn match tnoteItemBullet "^\s*\*\s" 
syn match tnoteComment    "^\s*::\s.*"
syn match tnoteComment    "\s::.*"
syn match tnoteCodeline   "^\t* \+.*"
syn match tnoteHeader     "^\s*#\+\s.*"
syn match tnoteCode       "`[^`]\+`"
syn match tnoteTag        "#\w\+"
syn match tnoteItalic     "_\w[^+]*\w_"
syn match tnoteBold       "\*\w[^*]*\w\*"
syn match tnoteDelete     "\~\w[^~]*\w\~"
syn match tnoteRelation   "\(^\|\s\+\)<[^>]\+>\(\s\|$\)"

syn match tnoteItem       "^\s*\*\s.*" contains=tnoteItemBullet,tnoteRelation,tnoteComment,tnoteCode

if exists('b:current_syntax')
  unlet b:current_syntax
endif
set foldmethod=indent foldlevel=0 foldminlines=0 foldenable
