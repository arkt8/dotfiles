" " Call CheckAutocmdEnablePHPFold on BufReadPost {{{1

function PhpFold()
"	set foldmethod=marker
"	set foldmarker={,}
	set foldexpr=getline(v:lnum)[0]==\\"\\t\\"
	set foldmethod=expr
	set foldnestmax=2
	set foldlevel=1
	set foldenable
endfunction

silent call PhpFold()

" Turn html comments into php delimiters, useful to use
" html comments to fill the gaps between elements which
" give imprevisible style misplacements.
hi! link htmlComment Delimiter
hi! htmlComment guibg=#051a25 guifg=#000000 gui=bold,italic
set noexpandtab


" vim:ft=vim:foldmethod=marker:nowrap:tabstop=4:shiftwidth=4
