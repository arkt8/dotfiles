" =============================================================================
" Vim color file (term.vim)
"    Maintainer: Thadeu de Paula
"   Last Change: 2021 08
"       Version: 1.0
" =============================================================================
" Friendly colors for 16 colors terminal
"
"set background=dark
hi clear

if exists("syntax_on") |  syntax reset | endif

let colors_name = "term"

" =============================================================================
" Main
" =============================================================================

let s:lalala='po'
lua <<EOF
local json=require'json'
local cfile=io.open("/home/thadeu/.cache/wal/colors.json","r" )
local colors=json.decode(cfile:read('*a')).colors
cfile:close()
vim.g.wal_color_00 = colors.color0
vim.g.wal_color_01 = colors.color1
vim.g.wal_color_02 = colors.color2
vim.g.wal_color_03 = colors.color3
vim.g.wal_color_04 = colors.color4
vim.g.wal_color_05 = colors.color5
vim.g.wal_color_06 = colors.color6
vim.g.wal_color_07 = colors.color7
vim.g.wal_color_08 = colors.color8
vim.g.wal_color_09 = colors.color9
vim.g.wal_color_09 = colors.color9
vim.g.wal_color_10 = colors.color10
vim.g.wal_color_11 = colors.color11
vim.g.wal_color_12 = colors.color12
vim.g.wal_color_13 = colors.color13
vim.g.wal_color_14 = colors.color14
vim.g.wal_color_15 = colors.color15
EOF

let g:wal_color_bg = "None"
let g:wal_color_fg = "None"
let g:wal_color_None = "None"
let g:wal_color_bg_chg  = "#001122"
let g:wal_color_fg_chg  = "#0b2136"
let g:wal_color_bg_warn = "#aa2423"
let g:wal_color_fg_warn = "#c24b2c"
let g:wal_color_bg_err  = "#322004"
let g:wal_color_fg_err  = "#ae0034"
let g:wal_color_bg_del  = "#320014"
let g:wal_color_bg_ok   = "#002211"
let g:wal_color_fg_ok   = "#006b36"

let s:color_00 = "0"  "black
let s:color_08 = "8"  "black
let s:color_01 = "1"  "red
let s:color_09 = "9"  "red
let s:color_02 = "2"  "green
let s:color_10 = "10" "green
let s:color_03 = "3"  "yellow
let s:color_11 = "11" "yellow
let s:color_04 = "4"  "blue
let s:color_12 = "12" "blue
let s:color_05 = "5"  "magenta
let s:color_13 = "13" "magenta
let s:color_06 = "6"  "cyan
let s:color_14 = "14" "cyan
let s:color_07 = "7"  "white
let s:color_15 = "15" "white
let s:color_bg = "None"
let s:color_fg = "None"
let s:color_None = "None"
let s:color_bg_chg = "yellow"
let s:color_fg_chg = "yellow"
let s:color_bg_warn = "yellow"
let s:color_fg_warn = "yellow"
let s:color_bg_del  = "red"
let s:color_bg_err  = "red"
let s:color_fg_err  = "red"
let s:color_bg_ok   = "green"
let s:color_fg_ok   = "green"


fun! s:X(group, bg, fg, attr)
    let l:cmd = "hi ".a:group.
    \ " ctermfg=".eval('s:color_'.a:fg).
    \ " ctermbg=".eval('s:color_'.a:bg).
    \ " guifg=".eval('g:wal_color_'.a:fg).
    \ " guibg=".eval('g:wal_color_'.a:bg)

  let l:cmd = l:cmd." cterm=".a:attr." gui=".a:attr
  exec l:cmd
endfun

" this is a comment
call s:X("Normal",       "bg", "fg", "None" )
call s:X("Comment",      "bg", "08", "italic" )
call s:X("NonText",      "00", "08", "None" )
call s:X("Whitespace",   "bg", "08", "None" )
call s:X("EndOfBuffer",  "bg", "00", "None" )
call s:X("VertSplit",    "bg", "08", "None" )
call s:X("LineNr",       "bg", "08", "None" )
call s:X("CursorLineNr", "bg", "00", "None" )
call s:X("StatusLineNC", "00", "08", "None" )
call s:X("StatusLine",   "00", "07", "None" )
call s:X("ColorColumn",  "00", "01", "None" )
call s:X("SpecialKey",   "bg", "07", "None" )
call s:X("Conceal",      "bg", "00", "None" )
"    -- Cursor", "bg", "07", "" )
"    -- lCursor", "bg", "07", "" )
"    -- CursorIM", "bg", "07", "" )
call s:X("CursorColumn", "00", "None", "None" )
call s:X("CursorLine",   "00", "None", "None" )
"    -- Directory", "bg", "07", "" )
call s:X("DiffAdd",		 "bg_ok",   "None", "None" )
call s:X("DiffChange",   "bg_chg",  "None", "None" )
call s:X("DiffText",     "fg_chg",  "None", "None" )
call s:X("DiffDelete",   "bg_err",  "bg_err", "None" )
"    -- TermCursor", "bg", "07", "" )
"    -- TermCursorNC", "bg", "07", "" )
call s:X("WarningMsg",   "bg", "03", "None" )
call s:X("Folded",       "bg", "08", "italic,bold" )
call s:X("FoldColumn",   "bg", "07", "None" )
call s:X("SignColumn",   "bg", "03", "None" )
call s:X("MoreMsg",      "bg", "07", "None" )
"    -- ModeMsg", "bg", "07", "" )
"    -- MsgArea", "bg", "07", "" )
"    -- MsgSeparator", "bg", "07", "" )
"    -- NormalNC", "bg", "07", "" )

call s:X("NormalFloat",  "bg", "07", "None" )
call s:X("Visual",       "bg", "13", "reverse" )
call s:X("VisualNOS",    "bg", "13", "reverse" )
call s:X("Pmenu",        "00", "07", "None" )
call s:X("PmenuSel",     "08", "07", "None" )
call s:X("PmenuSbar",    "08", "bg", "None" )
call s:X("PmenuThumb",   "07", "bg", "None" )
call s:X("Question",     "bg", "07", "None" )
call s:X("Search",       "bg", "03", "reverse" )
call s:X("IncSearch",    "bg", "03", "reverse" )
call s:X("Substitute",   "bg", "04", "reverse" )
call s:X("MatchParen",   "bg", "03", "bold,italic" )
"    QuickFixLine", "bg", "07", "" )
"    -- SpellBad", "bg", "07", "" )
"    -- SpellCap", "bg", "07", "" )
"    -- SpellLocal", "bg", "07", "" )
"    -- SpellRare", "bg", "07", "" )
"    StatusLine", "bg", "07", "" )
"    StatusLineNC", "bg", "07", "" )
call s:X("TabLineSel",  "02", "00", "None" )
call s:X("TabLine",     "bg", "07", "None" )
call s:X("TabLineFill", "bg", "07", "None" )
call s:X("Title",       "bg", "12", "bold" )
call s:X("Todo",  "bg", "15", "bold" )
call s:X("WildMenu",    "bg", "07", "None" )
"
"    -- These groups are not listed as default vim groups,
"    -- but they are defacto standard group names for syntax highlighting.
"    -- commented out groups should chain up to their "preferred" group by
"    -- default,
"    -- Uncomment and edit if you want more specific syntax highlighting.
"
call s:X("Constant",    "bg", "02", "None" )
"    -- String", "bg", "07", "" )
"    -- Character", "bg", "07", "" )
call s:X("Number",      "bg", "02", "None" )
call s:X("Float",       "bg", "02", "None" )
call s:X("Boolean",     "bg", "02", "bold" )

call s:X("Identifier",  "bg", "12", "None" )
call s:X("Functions",   "bg", "12", "None" ) " Language native
call s:X("Function",    "bg", "12", "bold" ) " Declaration
call s:X("FunctionCall","bg", "12", "None" ) " On call only

call s:X("Statement",   "bg", "09", "bold" )
call s:X("Conditional", "bg", "09", "None" )
call s:X("Repeat",      "bg", "11", "None" )
call s:X("Label",       "bg", "11", "bold" )
call s:X("Operator",    "bg", "11", "bold" )
"    -- Operator", "bg", "07", "" )
" call s:X("Keyword",     "bg", "04", "bold" )
hi! link Keyword Conditional
"    -- Exception", "bg", "07", "" )
"
call s:X("PreProc",     "bg", "05", "None" )
"    -- Include", "bg", "07", "" )
"    -- Define", "bg", "07", "" )
"    -- Macro", "bg", "07", "" )
"    -- PreCondit", "bg", "07", "" )
"
call s:X("Type",        "bg", "11", "None" )
call s:X("StorageClass","bg", "11", "None" )
call s:X("Structure",   "bg", "10", "None" )
call s:X("Typedef",     "bg", "11", "None" )
"
call s:X("Special",     "bg", "10", "None" )
"    -- SpecialChar", "bg", "07", "" )
"    -- Tag", "bg", "07", "" )
call s:X("Delimiter",   "bg", "10", "None" )
"    -- SpecialComment", "bg", "07", "" )
call s:X("Debug", "bg", "03", "italic" )
"
"    -- Underlined", "bg", "07", "" )
"    -- Bold", "bg", "07", "" )
"    -- Italic", "bg", "07", "" )
"
"    -- ("Ignore", below, may be invisible...)
"    -- Ignore", "bg", "07", "" )
"
"

call s:X("htmlStrike"     , "bg", "04", "strikethrough")
call s:X("htmlItalic"     , "bg", "12", "italic")
call s:X("htmlBold"       , "bg", "13", "bold")
call s:X("htmlBoldItalic" , "bg", "14", "bold,italic")

hi! Error ctermbg=88 ctermfg=15
hi! Warning ctermbg=58 ctermfg=15



hi! link pythonBuiltinFunction Functions
hi! link pythonBuiltinFunc     Functions
hi! link pythonBuiltinType     Functions
hi! link pythonClassVar        Functions
hi! link pythonFunction        Function
hi! link pythonFunctionCall    FunctionCall
hi! link pythonClass           Typedef
hi! link pythonRepeat          Repeat
hi! link pythonCondition       Conditional

hi! link phpConditional        Conditional
hi! link phpStatement          Statement
hi! link phpFunctions          Functions

" $ before variable name
hi! link phpVarSelector        Normal
hi! link phpIdentifier         Normal
hi! link phpEnvVar             Functions
hi! link phpIntVar             Functions
hi! link phpCoreConstant       Functions
hi! link phpRelation           Operator
hi! link phpComparison         Operator


" Html/Markdown
hi! link htmlH1                Title
hi! link htmlH2                Title
hi! link htmlH3                Title
hi! link htmlH4                Title
hi! link htmlH5                Title
hi! link htmlH6                Title
hi! link htmlString            PreProc

hi! link markdownCode          mkdCode
hi! link markdownCodeBlock     mkdCode
hi! link mkdCodeDelimiter      mkdCode
hi! link mkdCode               String
hi! link mkdLink               Type
hi! link mkdLinkTitle          Type
hi! link mkdLinkDefTarget      Type
hi! link mkdInlineUrl          Type
hi! link mkdFootnotes          mkdLink
hi! link mkdFootnote           Italic
hi! link mkdBold               htmlBold
hi! link mkdBoldItalic         htmlBoldItalic
hi! link mkdItalic             htmlItalic
hi! link mkdStrike             htmlStrike

"call s:X("CocFadeOut",   "None", "08", "underline")
call s:X("CocFloating",  "00", "fg", "None")
call s:X("CocUnderline", "None", "None", "None")

"hi! CocHintSign       guibg=#111f28 guifg=#445577

hi! Hint              guibg=#080f0f guifg=#668888
hi! link CocHintSign      hint
hi! link CocHintHighlight hint
hi! link ALEInfoSign      hint
hi! link ALEInfo          hint
"hi! link CocHintLine      clear
"hi! link ALEInfoLine      clear


hi! Error             guibg=#220011 guifg=#cc0044 gui=bold
hi! ErrorInline       guibg=None    guibg=#cc0044 gui=None
hi! link CocErrorSign      Error
hi! link CocErrorHighlight ErrorInline
hi! link ALEError          Error
hi! link ErrorMsg          Error
hi! link ALEErrorSign      Error
" ALESTyleErrorSign
" ALEErrorLine
" ALEStyleError

hi! CocWarningSign    guibg=#221100 guifg=#cc8800 gui=None
"CocWarningLine

hi! CocFadeOut        guifg=None    guibg=None    gui=italic
hi! link CocCodeLens Comment
hi! link ALEWarning CocHintSign

" CocSelectedLine
" CocInfoLine
" CocHintLine
" CocWarningLine
" CocWarnSign
" CocErrorLine
" ALEWarningSign
" ALESTyleWarningSign
" ALESignColumnWithErrors
" ALESignColumnWithoutErrors
" ALEWarningLine
" ALEStyleWarning



