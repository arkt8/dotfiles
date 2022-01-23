" junegunn/markdown.vim {{{
let g:vim_markdown_no_extensions_in_markdown = 0
"}}}

" junegunn/limelight.vim {{{
" Color name (:help cterm-colors) or ANSI code
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240
let g:limelight_conceal_guifg = '#133f4c'
"}}}

" junegunn/goyo.vim {{{
function! s:goyo_enter()
  if executable('tmux') && strlen($TMUX)
	silent !tmux set status off
	silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
  endif
  set noshowmode
  set noshowcmd
  set scrolloff=999
  Limelight
  " ...
endfunction

function! s:goyo_leave()
  if executable('tmux') && strlen($TMUX)
	silent !tmux set status on
	silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
  endif
  set showmode
  set showcmd
  set scrolloff=5
  Limelight!
  " ...
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
"}}}

" gitgutter {{{
let g:gitgutter_sign_added="» "
let g:gitgutter_sign_modified="~ "
let g:gitgutter_sign_modified_removed="« "
let g:gitgutter_sign_removed="« "
let g:gitgutter_sign_removed_above_and_below="« "
let g:gitgutter_sign_removed_first_line="- "
" }}}

" ale {{{
let g:ale_sign_error="×"
let g:ale_sign_warning="!"
let g:ale_sign_style_error="§"
let g:ale_sign_style_warning="§"
let g:ale_sign_info="»"
"let g:ale_linters = {'haskell': ['cabal_ghc', 'ghc-mod', 'hdevtools', 'hie', 'hlint', 'stack_build', 'stack_ghc']}
let g:ale_linters = {'haskell': ['stack_ghc']}
" }}}za






" vim: foldenable foldmarker={{{,}}} foldmethod=marker 


