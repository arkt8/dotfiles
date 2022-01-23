let s:conf_file=expand( $HOME.'/.config/nvim/.colorscheme.vim' )

function ColorAdjust()
"	hi! Whitespace guifg=#222222 guibg=None
"	hi! Normal guibg=None
	hi! SignColumn guibg=None
	hi! LineNr guibg=None
	hi! FoldColumn guibg=None
	hi! Folded guibg=None
"	hi! StatusLine guifg=#000000
	hi! clear VertSplit
	hi! link VertSplit LineNr
	hi! clear EndOfBuffer
	hi! EndOfBuffer guibg=None guifg=#000000
"	hi! CocCodeLens guifg=#303030
	hi! link CocCodeLens Comment 
	hi! FgCocErrorFloatBgCocFloating   guifg=#ff5555 guibg=NONE
	hi! FgCocWarningFloatBgCocFloating guifg=#ffaa55 guibg=NONE
	hi! FgCocInfoFloatBgCocFloating    guifg=#aaaaaa guibg=NONE
	hi! NormalFloat                    guifg=#aaaaaa guibg=#222222
	hi! Visual  guibg=#222222

	let g:terminal_color_8="#FFFFFF"
endfunction

"" Save colorscheme choice
"function s:colorSave()
"	call writefile( split(':colorscheme '.g:colors_name."\n", "\n"), s:conf_file )
"endfu
"
colorscheme term

"call ColorAdjust()
