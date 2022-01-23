" =============================================================================
" Vim color file (wal.vim)
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
let s:color_16 = "16" "blacker

let s:color_bg = "None"
let s:color_fg = "None"

fun! s:X(group, bg, fg, attr)
    let l:cmd = "hi ".a:group.
    \ " ctermfg=".a:fg.
    \ " ctermbg=".a:bg

  let l:cmd = l:cmd." cterm=".a:attr
  exec l:cmd
endfun

" this is a comment
call s:X("Normal",       s:color_bg, s:color_fg, "None" )
call s:X("Comment",      s:color_bg, s:color_01, "italic" )
call s:X("NonText",      s:color_bg, s:color_01, "None" )
call s:X("Whitespace",   s:color_bg, s:color_01, "None" )
call s:X("EndOfBuffer",  s:color_bg, s:color_01, "None" )
call s:X("VertSplit",    s:color_bg, s:color_01, "None" )
call s:X("LineNr",       s:color_bg, s:color_08, "None" )
call s:X("CursorLineNr", s:color_01, s:color_07, "None" )
call s:X("StatusLineNC", s:color_01, s:color_08, "None" )
call s:X("StatusLine",   s:color_01, s:color_07, "bold,italic" )
call s:X("ColorColumn",  s:color_00, s:color_01, "None" )
call s:X("SpecialKey",   s:color_bg, s:color_07, "None" )
call s:X("Conceal",      s:color_bg, s:color_00, "None" )
"    -- Cursor", s:color_bg, s:color_07, "" )
"    -- lCursor", s:color_bg, s:color_07, "" )
"    -- CursorIM", s:color_bg, s:color_07, "" )
call s:X("CursorColumn", s:color_00, "None", "None" )
call s:X("CursorLine",   s:color_00, "None", "None" )
"    -- Directory", s:color_bg, s:color_07, "" )
call s:X("DiffAdd",      s:color_10, s:color_00, "None" )
call s:X("DiffChange",   s:color_04, s:color_00, "None" )
call s:X("DiffText",     s:color_12, s:color_00, "None,bold" )
call s:X("DiffDelete",   s:color_00, s:color_00, "None" )
"    -- TermCursor", s:color_bg, s:color_07, "" )
"    -- TermCursorNC", s:color_bg, s:color_07, "" )
call s:X("Error",        s:color_01, s:color_bg, "None" )
call s:X("ErrorMsg",     s:color_bg, s:color_09, "None" )
call s:X("WarningMsg",   s:color_bg, s:color_03, "None" )
call s:X("Folded",       s:color_00, s:color_08, "None" )
call s:X("FoldColumn",   s:color_bg, s:color_01, "None" )
call s:X("SignColumn",   s:color_bg, s:color_03, "None" )
call s:X("MoreMsg",      s:color_bg, s:color_07, "None" )
"    -- ModeMsg", s:color_bg, s:color_07, "" )
"    -- MsgArea", s:color_bg, s:color_07, "" )
"    -- MsgSeparator", s:color_bg, s:color_07, "" )
"    -- NormalNC", s:color_bg, s:color_07, "" )

call s:X("NormalFloat", s:color_bg, s:color_07, "None" )
call s:X("Visual",      s:color_bg, s:color_06, "reverse" )
call s:X("VisualNOS",   s:color_bg, s:color_06, "reverse" )
call s:X("Pmenu",       s:color_00, s:color_07, "None" )
call s:X("PmenuSel",    s:color_08, s:color_07, "None" )
call s:X("PmenuSbar",   s:color_08, s:color_bg, "None" )
call s:X("PmenuThumb",  s:color_07, s:color_bg, "None" )
call s:X("Question",    s:color_bg, s:color_07, "None" )
call s:X("Search",       s:color_bg, s:color_03, "reverse" )
call s:X("IncSearch",    s:color_bg, s:color_03, "reverse" )
call s:X("Substitute",   s:color_bg, s:color_04, "reverse" )
call s:X("MatchParen",   s:color_bg, s:color_03, "bold,italic" )
"    QuickFixLine", s:color_bg, s:color_07, "" )
"    -- SpellBad", s:color_bg, s:color_07, "" )
"    -- SpellCap", s:color_bg, s:color_07, "" )
"    -- SpellLocal", s:color_bg, s:color_07, "" )
"    -- SpellRare", s:color_bg, s:color_07, "" )
"    StatusLine", s:color_bg, s:color_07, "" )
"    StatusLineNC", s:color_bg, s:color_07, "" )
call s:X("TabLineSel",  s:color_02, s:color_00, "None" )
call s:X("TabLine",     s:color_bg, s:color_07, "None" )
call s:X("TabLineFill", s:color_bg, s:color_07, "None" )
call s:X("Title",       s:color_bg, s:color_07, "None" )
call s:X("WildMenu",    s:color_01, s:color_07, "None" )
"
"    -- These groups are not listed as default vim groups,
"    -- but they are defacto standard group names for syntax highlighting.
"    -- commented out groups should chain up to their "preferred" group by
"    -- default,
"    -- Uncomment and edit if you want more specific syntax highlighting.
"
call s:X("Constant",    s:color_bg, s:color_02, "None" )
"    -- String", s:color_bg, s:color_02, "" )
"    -- Character", s:color_bg, s:color_02, "" )
call s:X("Number",      s:color_bg, s:color_02, "None" )
call s:X("Float",       s:color_bg, s:color_02, "None" )
call s:X("Boolean",     s:color_bg, s:color_02, "bold" )
"-----------------------------------------------------------
call s:X("Identifier",  s:color_bg, s:color_04, "None" )
call s:X("Functions",   s:color_bg, s:color_04, "None") " Language native
call s:X("Function",    s:color_bg, s:color_04, "None" )       " Declaration
call s:X("FunctionCall",s:color_bg, s:color_04, "None" )       " On call only
"-----------------------------------------------------------
call s:X("Statement",   s:color_bg, s:color_05, "bold" )
call s:X("Conditional", s:color_bg, s:color_05, "None" )
call s:X("Repeat",      s:color_bg, s:color_05, "None" )
call s:X("Label",       s:color_bg, s:color_05, "None" )
call s:X("Operator",    s:color_bg, s:color_05, "None" )
"    -- Operator", s:color_bg, s:color_07, "" )
" call s:X("Keyword",     s:color_bg, s:color_04, "bold" )
hi! link Keyword Conditional
"    -- Exception", s:color_bg, s:color_07, "" )
"
call s:X("PreProc",     s:color_bg, s:color_05, "None" )
"    -- Include", s:color_bg, s:color_07, "" )
"    -- Define", s:color_bg, s:color_07, "" )
"    -- Macro", s:color_bg, s:color_07, "" )
"    -- PreCondit", s:color_bg, s:color_07, "" )
"
call s:X("Type",        s:color_bg, s:color_06, "None" )
call s:X("StorageClass",s:color_bg, s:color_06, "None" )
call s:X("Structure",   s:color_bg, s:color_06, "None" )
call s:X("Typedef",     s:color_bg, s:color_06, "None" )
"
call s:X("Special",     s:color_bg, s:color_06, "None" )
"    -- SpecialChar", s:color_bg, s:color_07, "" )
"    -- Tag", s:color_bg, s:color_07, "" )
call s:X("Delimiter",   s:color_bg, s:color_06, "None" )
"    -- SpecialComment", s:color_bg, s:color_07, "" )
"    -- Debug", s:color_bg, s:color_07, "" )
"
"    -- Underlined", s:color_bg, s:color_07, "" )
"    -- Bold", s:color_bg, s:color_07, "" )
"    -- Italic", s:color_bg, s:color_07, "" )
"
"    -- ("Ignore", below, may be invisible...)
"    -- Ignore", s:color_bg, s:color_07, "" )
"
"
call s:X("Todo",  s:color_bg, s:color_15, "None" )
call s:X("Title", s:color_bg, s:color_15, "bold,italic")

call s:X("htmlStrike"     , s:color_bg, s:color_04, "strikethrough")
call s:X("htmlItalic"     , s:color_bg, s:color_12, "italic")
call s:X("htmlBold"       , s:color_bg, s:color_13, "bold")
call s:X("htmlBoldItalic" , s:color_bg, s:color_14, "bold,italic")

hi! Error ctermbg=88 ctermfg=15
hi! Warning ctermbg=58 ctermfg=15
hi! link ALEError Error
hi! link ALEWarning None



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


hi! link mkdCodeDelimiter      mkdCode
hi! link mkdCode               String
hi! link mkdLink               Type
hi! link mkdLinkTitle          Type
hi! link mkdLinkDefTarget      Type
hi! link mkdInlineUrl          Type
hi! link mkdUrl                PreProc
hi! link mkdFootnotes          mkdLink
hi! link mkdFootnote           Italic
hi! link mkdBold               htmlBold
hi! link mkdBoldItalic         htmlBoldItalic
hi! link mkdItalic             htmlItalic
hi! link mkdStrike               htmlStrike
