" URL: https://github.com/whatyouhide/vim-gotham
" Aurhor: Andrea Leopardi <an.leopardi@gmail.com>
" Version: 1.0.0
" License: MIT


" Bootstrap ===================================================================

hi clear
set termguicolors
if exists('syntax_on') | syntax reset | endif
set background=dark
let g:colors_name = 'Haskell'


" Helper functions =============================================================

" Execute the 'highlight' command with a List of arguments.
function! s:Highlight(args)
  exec 'highlight ' . join(a:args, ' ')
endfunction

function! s:AddGroundValues(accumulator, ground, color)
  let new_list = a:accumulator
  for [where, value] in items(a:color)
    call add(new_list, where . a:ground . '=' . value)
  endfor

  return new_list
endfunction

function! s:Col(group, fg_name, ...)
  " ... = optional bg_name

  let pieces = [a:group]

  if a:fg_name !=# ''
    let pieces = s:AddGroundValues(pieces, 'fg', s:colors[a:fg_name])
  endif

  if a:0 > 0 && a:1 !=# ''
    let pieces = s:AddGroundValues(pieces, 'bg', s:colors[a:1])
  endif
  if a:0 > 1 && a:2 !=# ''
	let pieces = s:AddGroundValues(pieces, '', a:2)
  endif

  call s:Clear(a:group)
  call s:Highlight(pieces)
endfunction

function! s:Attr(group, attr)
  let l:attrs = [a:group, 'term=' . a:attr, 'cterm=' . a:attr, 'gui=' . a:attr]
  call s:Highlight(l:attrs)
endfunction

function! s:Clear(group)
  exec 'highlight clear ' . a:group
endfunction


" Colors ======================================================================

" Let's store all the colors in a dictionary.
let s:colors = {}

" Base colors.
let s:colors.base0 = { 'gui': '#131119', 'cterm': 0 }
let s:colors.base1 = { 'gui': '#282239', 'cterm': 8 }
let s:colors.base2 = { 'gui': '#453a62', 'cterm': 10 }
let s:colors.base3 = { 'gui': '#5e5086', 'cterm': 12 }
let s:colors.base4 = { 'gui': '#8273ac', 'cterm': 11 }
let s:colors.base5 = { 'gui': '#857aa4', 'cterm': 14 }
let s:colors.base6 = { 'gui': '#b2a9cc', 'cterm': 7 }
let s:colors.base7 = { 'gui': '#d8d6e0', 'cterm': 15 }

" Other colors.
let s:colors.red     = { 'gui': '#cd75c8', 'cterm': 1  }
let s:colors.orange  = { 'gui': '#cda175', 'cterm': 9  }
let s:colors.yellow  = { 'gui': '#cda175', 'cterm': 3  }
let s:colors.magenta = { 'gui': '#cd75c8', 'cterm': 13 }
let s:colors.violet  = { 'gui': '#4e5166', 'cterm': 5  }
let s:colors.blue    = { 'gui': '#554455', 'cterm': 4  }
let s:colors.cyan    = { 'gui': '#453a62', 'cterm': 6  }
let s:colors.green   = { 'gui': '#2aa889', 'cterm': 2  }

let s:colors.dark_red     = { 'gui': '#c23127', 'cterm': 1  }
let s:colors.dark_orange  = { 'gui': '#cda175', 'cterm': 9  }
let s:colors.dark_yellow  = { 'gui': '#cda175', 'cterm': 3  }
let s:colors.dark_magenta = { 'gui': '#cd75c8', 'cterm': 13 }
let s:colors.dark_violet  = { 'gui': '#4e5166', 'cterm': 5  }
let s:colors.dark_blue    = { 'gui': '#554455', 'cterm': 4  }
let s:colors.dark_cyan    = { 'gui': '#6ca2a7', 'cterm': 6  }
let s:colors.dark_green   = { 'gui': '#2aa889', 'cterm': 2  }

let s:colors.diff_del  = { 'gui': '#c23127', 'cterm': 1  }
let s:colors.diff_add  = { 'gui': '#2aa889', 'cterm': 2  }
let s:colors.diff_chg  = { 'gui': '#195466', 'cterm': 4  }

" Neovim :terminal colors.
let g:terminal_color_0  = get(s:colors.base0, 'gui')
let g:terminal_color_8  = g:terminal_color_0
let g:terminal_color_1  = get(s:colors.red, 'gui')
let g:terminal_color_9  = g:terminal_color_1
let g:terminal_color_2  = get(s:colors.green, 'gui')
let g:terminal_color_10 = g:terminal_color_2
let g:terminal_color_3  = get(s:colors.yellow, 'gui')
let g:terminal_color_11 = g:terminal_color_3
let g:terminal_color_4  = get(s:colors.blue, 'gui')
let g:terminal_color_12 = g:terminal_color_4
let g:terminal_color_5  = get(s:colors.violet, 'gui')
let g:terminal_color_13 = g:terminal_color_5
let g:terminal_color_6  = get(s:colors.cyan, 'gui')
let g:terminal_color_14 = g:terminal_color_6
let g:terminal_color_7  = get(s:colors.base6, 'gui')
let g:terminal_color_15 = g:terminal_color_7


" Native highlighting ==========================================================

let s:background = 'base0'
let s:linenr_background = 'base1'

" Everything starts here.
call s:Col('Normal', 'base6', s:background)

" Line, cursor and so on.
call s:Col('Cursor', 'base1', 'base6')
call s:Col('CursorLine', '', 'base1')
call s:Col('CursorColumn', '', 'base1')

" Sign column, line numbers.
call s:Col('LineNr', 'blue', s:linenr_background)
call s:Col('CursorLineNr', 'base5', s:linenr_background)
call s:Col('SignColumn', '', s:linenr_background)
call s:Col('ColorColumn', '', s:linenr_background)

" Visual selection.
call s:Col('Visual', '', 'base3')

" Easy-to-guess code elements.
call s:Col('Comment', 'blue')
call s:Col('String', 'green')
call s:Col('Number', 'orange')
call s:Col('Statement', 'base5')
call s:Col('Special', 'orange')
call s:Col('Identifier', 'base5')

" Constants, Ruby symbols.
call s:Col('Constant', 'magenta')

" Some HTML tags (<title>, some <h*>s)
call s:Col('Title', 'orange')

" <a> tags.
call s:Col('Underlined', 'yellow')
call s:Attr('Underlined', 'underline')

" Types, HTML attributes, Ruby constants (and class names).
call s:Col('Type', 'orange')

" Stuff like 'require' in Ruby.
call s:Col('PreProc', 'red')

" Tildes on the bottom of the page.
call s:Col('NonText', 'blue')

" Concealed stuff.
call s:Col('Conceal', 'cyan', s:background)

" TODO and similar tags.
call s:Col('Todo', 'magenta', s:background)

" The column separating vertical splits.
call s:Col('VertSplit', 'blue', s:linenr_background)
call s:Col('StatusLineNC', 'blue', 'base2')

" Matching parenthesis.
call s:Col('MatchParen', 'base6', 'orange')

" Special keys, e.g. some of the chars in 'listchars'. See ':h listchars'.
call s:Col('SpecialKey', 'base3')

" Folds.
call s:Col('Folded', 'base6', 'blue')
call s:Col('FoldColumn', 'base5', 'base3')

" Searching.
call s:Col('Search', 'base2', 'yellow')
call s:Attr('IncSearch', 'reverse')

" Popup menu.
call s:Col('Pmenu', 'base6', 'base2')
call s:Col('PmenuSel', 'base7', 'blue')
call s:Col('PmenuSbar', '', 'base2')
call s:Col('PmenuThumb', '', 'blue')

" Command line stuff.
call s:Col('ErrorMsg', 'red', 'base1')
call s:Col('Error', 'red', 'base1')
call s:Col('ModeMsg', 'blue')
call s:Col('WarningMsg', 'red')

" Wild menu.
" StatusLine determines the color of the non-active entries in the wild menu.
call s:Col('StatusLine', 'base5', 'base2')
call s:Col('WildMenu', 'base7', 'cyan')

" The 'Hit ENTER to continue prompt'.
call s:Col('Question', 'green')

" Tab line.
call s:Col('TabLineSel', 'base7', 'blue')  " the selected tab
call s:Col('TabLine', 'base6', 'base2')     " the non-selected tabs
call s:Col('TabLineFill', 'base0', 'base0') " the rest of the tab line

" Spelling.
call s:Col('SpellBad', 'base7', 'red')
call s:Col('SpellCap', 'base7', 'blue')
call s:Col('SpellLocal', 'yellow')
call s:Col('SpellRare', 'base7', 'violet')

" Diffing.
call s:Col('DiffAdd', 'base7', 'green')
call s:Col('DiffChange', 'base7', 'blue')
call s:Col('DiffDelete', 'base7', 'red')
call s:Col('DiffText', 'base7', 'cyan')
call s:Col('DiffAdded', 'green')
call s:Col('DiffChanged', 'blue')
call s:Col('DiffRemoved', 'red')
call s:Col('DiffSubname', 'blue')

" Directories (e.g. netrw).
call s:Col('Directory', 'cyan')


" Programming languages and filetypes ==========================================

" Ruby.
call s:Col('rubyDefine', 'blue')
call s:Col('rubyStringDelimiter', 'green')

" HTML (and often Markdown).
call s:Col('htmlArg', 'blue')
call s:Col('htmlItalic', 'magenta')
call s:Attr('htmlItalic', 'italic')
call s:Col('htmlBold', 'cyan', '')
call s:Attr('htmlBold', 'bold')
call s:Col('htmlBoldItalic', 'cyan', '')
call s:Attr('htmlBoldItalic', 'bold,italic')

" Python                                                                                                                   
call s:Col('pythonStatement', 'blue')


" Plugin =======================================================================

" GitGutter
call s:Col('GitGutterAdd', 'green', s:linenr_background)
call s:Col('GitGutterChange', 'cyan', s:linenr_background)
call s:Col('GitGutterDelete', 'orange', s:linenr_background)
call s:Col('GitGutterChangeDelete', 'magenta', s:linenr_background)

" CtrlP
call s:Col('CtrlPNoEntries', 'base7', 'orange') " no entries
call s:Col('CtrlPMatch', 'green')               " matching part
call s:Col('CtrlPPrtBase', 'blue')             " '>>>' prompt
call s:Col('CtrlPPrtText', 'cyan')              " text in the prompt
call s:Col('CtrlPPtrCursor', 'base7')           " cursor in the prompt

" unite.vim
call s:Col('UniteGrep', 'base7', 'green')
let g:unite_source_grep_search_word_highlight = 'UniteGrep'

" ale https://github.com/w0rp/ale
call s:Col('ALEWarningSign', 'yellow', s:linenr_background)
call s:Col('ALEErrorSign', 'red', s:linenr_background)

" neomake https://github.com/neomake/neomake
call s:Col('NeomakeWarningSign', 'yellow', s:linenr_background)
call s:Col('NeomakeErrorSign', 'red', s:linenr_background)
call s:Col('NeomakeWarning', 'yellow')
call s:Col('NeomakeError', 'red')

" Cleanup =====================================================================

unlet s:colors
unlet s:background
unlet s:linenr_background
