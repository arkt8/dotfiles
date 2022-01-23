set sw=2 sts=2 ts=2 et

fu! HaskellCommentRemove()
	silent s/^--\+\( >>>\)\?//g
endfu
fu! HaskellInlineCall()
	silent s/^\(-- >>>\)\?/-- >>>/g
endfu

inoremap <buffer> <M-.> <Esc>:call HaskellInlineCall()<Enter>
nnoremap <buffer> <M-,> <Esc>:call HaskellCommentRemove()<Enter>
nnoremap <buffer> <F12> <Esc>:silent exec(':5sp \| :terminal stack build')<Enter>
inoremap <buffer> <F12> <Esc>:silent exec(':5sp \| :terminal stack build')<Enter>
set indentexpr=

" For plugin neovimhaskell/haskell-vim
let g:haskell_indent_disable=1
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
