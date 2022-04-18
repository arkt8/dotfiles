let s:plugin_dir=expand('<sfile>:p:h').'/../'

fu! Ide_Python_Formatter()
	execute( expand( '1,\$!yapf --style='.s:plugin_dir.'/format-python.conf --') )
endfu


fu! Ide_Python()

	" For plug vim-python/python-syntax
	let g:python_version_3 = 1
	let g:python_highlight_space_errors = 0 "incomoda pra dedéu
	let g:python_highlight_all = 1
	let g:python_slow_sync = 0

	command! F call Ide_Python_Formatter()
	command! X !/usr/bin/env python %
endfu

au BufWinEnter,BufEnter,BufRead *.py call Ide_Python()
call Ide_Python()


setlocal sts=4 sw=4 ts=4 expandtab
inoremap <buffer><silent> ;R :CocCommand pyright.restartserver<Enter>
nnoremap <buffer><silent> <C-x> <Esc>:w!<Enter>:!python %<Enter>
