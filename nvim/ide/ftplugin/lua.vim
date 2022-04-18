setlocal et ts=3 sw=3 sts=3

" Formatting
"command! F :1,$!lua-format -c $HOME/.config/nvim/ide/format-lua.conf --
" Execution
hi! link luaFuncKeyword  Functions
hi! link luaFunction     Function
hi! link luaFuncId       Identifier
hi! link luaFuncCall     FunctionCall
hi! link luaLocal        Statement
hi! link luaFuncArgComma luaFuncParens
hi! link luaFuncArgName  Noise
hi! link luaFuncArgs     luaFuncArgName

hi! link luaGotoLabel Identifier
hi! link luaGoto      Statement

hi! link luaCond         Conditional
hi! link luaElse         Conditional
hi! link luaIfThen       Conditional
hi! link luaElseifThen   Conditional
hi! link luaIn           RepeatOperator

hi! link luaTable        Type
hi! link luaBracket      Delimiter
hi! link luaBrackets     Delimiter
hi! link luaBraces       Delimiter
hi! link luaFuncParens   Delimiter
hi! link luaParens       Delimiter
hi! link luaBraceError   Error
hi! link luaFor          Repeat
hi! link luaRepeat       Repeat
hi! link luaStatement    Statement

hi! link luaNumber       Number
hi! link luaString       String
hi! link luaString2      Character
hi! link luaConstant     Constant

hi! link luaDocTag       SpecialComment



setlocal foldmethod=syntax
