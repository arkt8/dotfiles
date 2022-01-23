
" Corresponds to ~/.config/nvim/ide/external/js/node_modules
let s:bindir="$HOME/.local/share/nvim-ext/js/node_modules/"
fu! Ide_Javascript_Minify()
	if ( g:minjs != 0 )
		echom 'Minifying ( g:minjs=1 )'
		"silent
		execute( expand(':!'.s:bindir.'/babel-minify/bin/minify.js % -o '.expand('%:s/\(\.\?[^.]*$\)/.min\1/')) )
	else
		echom 'Minify disabled ( g:ide_m:inify=0 )'
		silent execute( expand(':!rm '.expand('%:s/\(\.\?[^.]*$\)/.min\1/')) )
	else
	endif
	redraw!
endfu

fu! Ide_Javascript_Formatter()
	echom 'Formatting'
	silent 1,$!standard --fix --stdin 2>/dev/null
	"silent execute(expand(':1,\$!'.s:bindir.'/js-beautify/js/bin/js-beautify.js -j -P -s 2 -w 80 --good-stuff'))
endfu

fu! Ide_Javascript()
	setlocal sts=2 ts=2 sw=2 noet
	if ! &diff | setlocal foldmethod=marker foldmarker=//{,//} foldlevel=0 foldenable | endif
	command! F call Ide_Javascript_Formatter()
	command! X !/usr/bin/env node %
	if (! exists( 'g:minjs' ))
		let g:minjs = 1
	endif
endfu

augroup Ide_Javascript_Augroup
	au!
	" -- BufEnter folds all, everytime entereing in the split
	"au BufWinEnter,BufEnter,BufRead *.js call Ide_Javascript()
	au BufWinEnter,BufRead *.js call Ide_Javascript()
	au BufWritePost *.js call Ide_Javascript_Minify()
augroup End

function Ide_FoldText()
	let line = getline(v:foldstart)
	let sub = substitute( line, '\s*//{\s*',' * ','g')
	let sub = substitute( sub, '//}','','g')
	let sub = substitute( sub, '\s\s\+','','g')
	let start = substitute( v:folddashes, '^.', '', 'g' )
	return start . sub
endfunction

setlocal foldtext=Ide_FoldText()

ALEDisableBuffer
