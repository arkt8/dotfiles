let s:plugin_dir="$HOME/.local/share/nvim-ext/"

fu! Ide_PHP_Formatter()
	1,$!phpcbf --standard=PSR12 --
endfu


fu! Ide_PHP()
	setlocal sts=4 sw=4 ts=4 noet autoindent
	command! F call Ide_PHP_Formatter()
	command! X !/usr/bin/env php
endfu

au BufWinEnter,BufEnter,BufRead *.php call Ide_PHP()

