let s:plugin_dir="$HOME/.local/share/nvim-ext/"

" ALE Config
let g:ale_php_phpcbf_standard = 'PSR12'
let g:ale_php_phpcs_standard = 'PSR12'
let g:ale_php_phpstan_executable = s:plugin_dir.'php/vendor/bin/phpstan'
let g:ale_php_phpstan_level = 7


fu! Ide_PHP_Formatter()
	1,$!phpcbf --standard=PSR12 --
endfu


fu! Ide_PHP()
	setlocal sts=4 sw=4 ts=4 et autoindent
	command! F call Ide_PHP_Formatter()
	command! X !/usr/bin/env php
endfu

au BufWinEnter,BufEnter,BufRead *.php call Ide_PHP()

ALEDisableBuffer
