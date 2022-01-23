fu! Ide_Lua()
	setlocal et ts=3 sw=3 sts=3

	" Formatting
	"command! F :1,$!lua-format -c $HOME/.config/nvim/ide/format-lua.conf --

	" Execution
	command! X !/usr/bin/env lua %
endfu

au BufWinEnter,BufEnter,BufRead *.lua call Ide_Lua()
call Ide_Lua()
