"Environment
let $PYTHONPYCACHEPREFIX=$HOME.'/.pyc'

lua <<END_OF_MAIN_LUA_CONF
package.path=package.path..';/usr/share/lua/5.1/?.lua;/usr/share/lua/5.1/?/init.lua'
package.cpath=package.cpath..';/usr/lib/x86_64-linux-gnu/lua/5.1/?.so;/usr/lib/lua/5.1/?.so'

END_OF_MAIN_LUA_CONF

:let g:mapleader = '\'
:let g:netrw_banner = 0


" A ordem dos tratores altera o viaduto!
if &diff == v:false
	runtime! plugged.vim
endif


" for i in cplugs | let &runtimepath.=",~/.config/nvim/".i | endfor
let &runtimepath.=expand(",$HOME/.config/nvim/ide")

:set mouse=a nomousehide 

"" Window
set splitright " Vertical splits open right
set splitbelow " Vertical splits open below
set modelineexpr
set timeoutlen=3000

"" Line conf
	set autoindent
	set smartindent
	set nowrap
	set wildmenu
	set noexpandtab
	set hlsearch           " Hilight search matched
	set ruler              " Show line number and column number on status line
	set tabstop=4          " columns used on tab (default=8)
	set shiftwidth=4       " columns used on softwidth
	set softtabstop=4
	set background=dark
	set nofoldenable
	set numberwidth=2      " use <,l> to toggle display line number
	set number norelativenumber
	set colorcolumn=80
	set nocursorline
	"set list listchars=tab:⎬\ ,trail:▓,precedes:⧼,extends:⧽ "Make tabs and endline empty visible
	"set list listchars=tab:𝄄\ ,trail:▓,precedes:⧼,extends:⧽ "Make tabs and endline empty visible
	set list listchars=tab:│\ ,trail:*,precedes:«,extends:» "Make tabs and endline empty visible

"" FILES CONF
set noswapfile nobackup
autocmd FocusLost * silent! wa " Automatically save file

"" Session & History
"set shada=%,'500,@500,:500,/100,h,\"20,n~/.local/nvim/shada
"set shadafile=~/.local/nvim/shada
set backupskip+=*.asc
set clipboard+=unnamedplus

"" VIMDIFF
if &diff
	set noreadonly

	:" Re-enable or update diff highlights
	:imap <F5> :set hl&:diffupdatei
	:map <F5> :set hl&:diffupdate

	" Disable diff highlights
	:imap <S-F5> :set hl+=A:none,C:none,D:none,T:nonei
			:map <S-F5> :set hl+=A:none,C:none,D:none,T:none
	set scrollbind cursorbind

	"colorscheme gotham
endif


set incsearch hlsearch
set ignorecase smartcase " Case insensitive matches
" Useful symbols
"      ¶  ⎇  Ξ           



hi! link NeomakeErrorSignDefault ErrorMsg
hi! link NeomakeErrorSign ErrorMsg

map <leader>t :vs ~/.todo.md<return>


" ALE Config
let g:ale_php_phpcbf_standard = 'PSR2'
let g:ale_php_phpcs_standard = 'PSR2'

" vim: set foldenable foldmethod=indent:
