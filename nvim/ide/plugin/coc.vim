if &diff == v:false && $SSH_CONNECTION == ""
	function! s:show_documentation()
	  if (index(['vim','help'], &filetype) >= 0)
		execute 'h '.expand('<cword>')
	  elseif (coc#rpc#ready())
		call CocActionAsync('doHover')
	  else
		execute '!' . &keywordprg . " " . expand('<cword>')
	  endif
	endfunction

"	" Use <c-space> to trigger completion.
"	if has('nvim')
"	  inoremap <silent><expr> <c-space> coc#refresh()
""	else
"	  inoremap <silent><expr> <c-@> coc#refresh()
"	endif

	" Make <Tab> auto-select the first completion item and notify coc.nvim to
	" format on enter, <cr> could be remapped by other vim plugin
	inoremap <silent><expr> <tab> pumvisible() ? coc#_select_confirm()
								 \: "\<C-g>u\<tab><c-r>=coc#on_enter()\<CR>"


	" Use `[g` and `]g` to navigate diagnostics
	" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
	nmap <silent> [g <Plug>(coc-diagnostic-prev)
	nmap <silent> ]g <Plug>(coc-diagnostic-next)

	" GoTo code navigation.
	nmap <silent> gd <Plug>(coc-definition)
	nmap <silent> gy <Plug>(coc-type-definition)
	nmap <silent> gi <Plug>(coc-implementation)
	nmap <silent> gr <Plug>(coc-references)
	"set statusline=%m\ %f%=\ %c:%l\ \ \ %P\ \ \ %y
	set statusline=%l:%c\ %m\ %<%f%=
	set statusline+=\ %{coc#status()}%{get(b:,'coc_current_function','')}
	set statusline+=\ <\ %Y
	"set statusline=%{coc#status()}%{get(b:,'coc_current_function','')} 

	" Use K to show documentation in preview window.
	nnoremap <silent>K :call <SID>show_documentation()<CR>

	nnoremap <nowait><expr> <C-Down> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-Down>"
	nnoremap <nowait><expr> <C-Up> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-Up>"
	inoremap <nowait><expr> <C-Down> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<C-Down>"
	inoremap <nowait><expr> <C-Up> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<C-Up>"
"	autocmd User CocOpenFloat call nvim_win_set_config(g:coc_last_float_win, {'relative': 'cursor', 'anchor': "NW", 'row':1 , 'col': 5})
"	autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
	"autocmd User CocOpenFloat call nvim_win_set_width(g:coc_last_float_win, 9999)
endif
