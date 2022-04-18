" =============================================================================
" Vim color file (term.vim)
"    Maintainer: Thadeu de Paula
"   Last Change: 2021 08
"       Version: 1.0
" =============================================================================
" Friendly colors for 16 colors terminal
"
"set background=dark
"hi clear

"if exists("syntax_on") |  syntax reset | endif

let colors_name = "wal"

" =============================================================================
" Main
" =============================================================================

lua <<EOF
do
local both, color_decompose,color_compose
local sum,sub,mix
local chsum,chsub,chmix


function color_decompose(rgb)
   local r,g,b = rgb:match('(..)(..)(..)$')
   return tonumber(r,16),tonumber(g,16),tonumber(b,16)
end

function color_compose(r,g,b)
   return string.format('#%.2x%.2x%.2x',r,g,b)
end

function chsum(c1,c2)
   return math.max(0,math.min(255,c1+c2))
end

function chsub(c1,c2)
   return math.max(0,math.min(255,c1-c2))
end

function chmix(c1,c2,ratio)
   return math.max(0,math.min(255,math.floor( c1 + (math.abs(c1-c2) * ratio) )))
end

function sum(rgb1,rgb2)
   local r1,g1,b1 = color_decompose(rgb1)
   local r2,g2,b2 = color_decompose(rgb2)
   local r = chsum(r1,r2)
   local g = chsum(g1,g2)
   local b = chsum(b1,b2)
   return color_compose(r,g,b)
end

function sub(rgb1,rgb2)
   local r1,g1,b1 = color_decompose(rgb1)
   local r2,g2,b2 = color_decompose(rgb2)
   local r = chsub(r1,r2)
   local g = chsub(g1,g2)
   local b = chsub(b1,b2)
   return color_compose(r,g,b)
end

function mix(rgb1, rgb2, ratio)
   local r1,g1,b1 = color_decompose(rgb1)
   local r2,g2,b2 = color_decompose(rgb2)
   local r = chmix(r1,r2, ratio)
   local g = chmix(g1,g2, ratio)
   local b = chmix(b1,b2, ratio)
   return color_compose(r,g,b)
end

------ Colors ------
local wal
local json=require'json'
local cfile=io.open("/home/thadeu/.cache/wal/colors.json","r" )
wal=json.decode(cfile:read("*a"))
cfile:close()

local walcolors = wal.colors
local walspecial = wal.special

local colors={}
for i=0,15,1 do
   colors[i]=walcolors['color'..i]
end
colors.bg=walspecial.background or colors[0]
colors.fg=walspecial.foreground or colors[15]

local guicolors={
  bg = colors.bg,
  fg = colors.fg,
  bg_chg  = "#001122",
  fg_chg  = "#0b2136",
  bg_warn = "#aa2423",
  fg_warn = "#c24b2c",
  bg_err  = "#322004",
  fg_err  = "#ae0034",
  bg_del  = "#320014",
  bg_ok   = "#002211",
  fg_ok   = "#006b36",
  dimm0   = sum(colors.bg,'#040404'),
  dimm1   = sum(colors.bg,'#080808'),
  dimm2   = sum(colors.bg,'#1f1f1f'),
  error   = "#cc0044",
}

local noguicolors = {
  bg_chg = "yellow",
  fg_chg = "yellow",
  bg_warn = "yellow",
  fg_warn = "yellow",
  bg_del  = "red",
  bg_err  = "red",
  fg_err  = "red",
  bg_ok   = "green",
  fg_ok   = "green",
}

function Darkens()
  colors.bg = sub(colors.bg,'#080808')
  vim.cmd("hi! Normal guibg="..colors.bg)
end

function hi(syntax,guibg,guifg,gui)
  vim.cmd( ([[hi! %s guibg=%s guifg=%s gui=%s]]):format(syntax,guibg,guifg,gui or "None") )
end

function both(name,bg,fg,attr)
  local guibg, guifg
  if type(bg) == "string" then
    guibg=guicolors[bg] or "None"
    bg=noguicolors[bg] or "None"
  else
    guibg=colors[bg]
  end
  if type(fg) == "string" then
    guifg=guicolors[fg] or "None"
    fg=noguicolors[fg] or "None"
  else
    guifg=colors[fg]
  end

  local cmd = ([[hi! %s ctermbg=%s ctermfg=%s guibg=%s guifg=%s cterm=%s gui=%s]]):format(
      name, bg, fg, guibg, guifg, attr, attr
  )
  vim.cmd(cmd)
end


both("Normal",       "bg", "fg", "None" )
both("Comment",      "None", 8, "italic" )
hi("Comment","None",mix(colors[8],colors.fg,0.24),"italic")
both("NonText",      "00", 8, "None" )
both("Whitespace",   "None", 8, "None" )
both("EndOfBuffer",  "None", 0, "None" )
both("VertSplit",    "None", 8, "None" )
vim.cmd("hi! VertSplit guifg="..guicolors.dimm2)
both("LineNr",       "None", 0, "None" )
vim.cmd("hi! LineNr guifg="..guicolors.dimm2)
both("CursorLineNr", "None", 0, "None" )
both("StatusLineNC",    0, 8, "None" )
both("StatusLine",      0, 7, "None" )
vim.cmd("hi! StatusLine guibg="..guicolors.dimm2)
vim.cmd("hi! StatusLineNC guibg="..guicolors.dimm1)
both("ColorColumn",     0, 1, "None" )
vim.cmd("hi! ColorColumn guibg="..guicolors.dimm0)
both("SpecialKey",   "None", 7, "None" )
both("Conceal",      "None", 0, "None" )
--vim.cmd("hi! Error guibg=#220011 guifg=#cc0044 gui=bold")
--vim.cmd("hi! ErrorInline guibg=#220011 guifg=#cc0044 gui=bold")
hi("Error",mix(colors.bg,guicolors.error,0.2),mix(guicolors.error,colors.fg,0.2),"italic")
hi("ErrorInline",guicolors.error,mix(guicolors.error,colors.fg,0.7),"italic")
hi("FgCocErrorFloatBgCocFloating","None",mix(guicolors.error,colors.fg,0.7))
-- this is a comment
--    -- Cursor", "None", "07", "" )
--    -- lCursor", "None", "07", "" )
--    -- CursorIM", "None", "07", "" )
both("CursorColumn", 0, "None", "None" )
both("CursorLine",   0, "None", "None" )
both("Directory",    "None", 11, "None" )
both("DiffAdd",      "bg_ok",   "None", "None" )
both("DiffChange",   "bg_chg",  "None", "None" )
both("DiffText",     "fg_chg",  "None", "None" )
both("DiffDelete",   "bg_err",  "bg_err", "None" )
--    -- TermCursor", "None", "07", "" )
--    -- TermCursorNC", "None", "07", "" )
both("WarningMsg",   "None", 3, "None" )
both("Folded",       "None", 6, "italic" )
both("FoldColumn",   "None", 6, "None" )
both("SignColumn",   "None", 3, "None" )
both("MoreMsg",      "None", 7, "None" )
--    -- ModeMsg", "None", 7, "" )
--    -- MsgArea", "None", 7, "" )
--    -- MsgSeparator", "None", 7, "" )
--    -- NormalNC", "None", 7, "" )

both("NormalFloat",  "None", 7, "None" )
both("Visual",       "None", 13, "reverse" )
both("VisualNOS",    "None", 13, "reverse" )
both("Pmenu",        "None", 7, "None" )
vim.cmd("hi! Pmenu guibg="..guicolors.dimm1)
both("PmenuSel",     "08",   7, "None" )
vim.cmd("hi! PmenuSel gui=bold guibg="..guicolors.dimm2)
both("PmenuSbar",    "08",   "bg", "None" )
both("PmenuThumb",   "07",   "bg", "None" )
both("Question",     "None", 7, "None" )
both("Search",       "None", 3, "reverse" )
both("IncSearch",    "None", 3, "reverse" )
both("Substitute",   "None", 4, "reverse" )
both("MatchParen",   "None", 3, "bold,italic" )
--both("QuickFixLine", "None", 7, "" )
--both("SpellBad", "None", 7, "" )
--both("SpellCap", "None", 7, "" )
--both("SpellLocal", "None", 7, "" )
--both("SpellRare", "None",  7, "" )
--both("StatusLine", "None",    7, "" )
--both("StatusLineNC", "None",  7, "" )
both("TabLineSel",  2, 0, "None" )
both("TabLine",     8, 7, "None" )
both("TabLineFill", 0, 7, "None" )
both("Title",       "None", "12", "bold" )
both("Todo",  "None", 15, "bold" )
both("WildMenu",    "None", 7, "None" )

--
-- These groups are not listed as default vim groups,
-- but they are defacto standard group names for syntax highlighting.
-- commented out groups should chain up to their "preferred" group by
-- default,
-- Uncomment and edit if you want more specific syntax highlighting.
--
both("Constant",    "None",  14, "None" )
both("String",      "None",  10, "None" )
both("Character",   "None",  10, "None" )
both("Number",      "None",  10, "None" )
both("Float",       "None",  10, "None" )
both("Boolean",     "None",  10, "bold" )

both("Functions",   "None", 9, "Italic" ) -- Language native
both("Function",    "None", 9, "Italic" ) -- Declaration
both("Identifier",  "None", 15, "None" )
both("FunctionCall","None", 15, "None" ) -- On call only

both("Delimiter",   "None", 3, "None" )

both("Repeat",         "None", 5, "italic" )
both("RepeatOperator", "None", 5, "italic")
both("Statement",      "None", 1, "italic" )

both("Conditional", "None", 3, "Italic" )
both("Operator",    "None", 3, "Bold,Italic" )

both("Label",       "None", 14, "None" )
both("Keyword",     "None", 14, "italic" )
--both("Exception",   "None",  7, "" )

both("PreProc",     "None", "13", "italic" )
--both("Include",     "None", 7, "" )
--both("Define",      "None", 7, "" )
--both("Macro",       "None", 7, "" )
--both("PreCondit",   "None", 7, "" )

both("Type",        "None", 03, "bold" )
both("StorageClass","None", 03, "None" )
both("Structure",   "None", 03, "italic" )
both("Typedef",     "None", 03, "bold" )
--
both("Special",     "None", 9, "italic" )
--    -- SpecialChar", "None", 7, "" )
--    -- Tag",         "None", 7, "" )
both("SpecialComment", "None", 8, "bold,italic" )
both("Debug",          "None", 3, "italic" )
--
--    -- Underlined", "None", 7, "" )
--    -- Bold",       "None", 7, "" )
--    -- Italic",     "None", 7, "" )
--
--    -- ("Ignore", below, may be invisible...)
--    -- Ignore", "None", 7, "" )
--
--

both("htmlStrike"     , "None", 4, "strikethrough")
both("htmlItalic"     , "None", 12, "italic")
both("htmlBold"       , "None", 13, "bold")
both("htmlBoldItalic" , "None", 14, "bold,italic")

both("CocFadeOut",    "None",      8, "underline")
both("CocFloating",        0,   "fg", "None")
both("CocUnderline",  "None", "None", "None")
both("Hint",               8,      0, "Italic")
vim.cmd("hi! Hint guibg="..guicolors.dimm1.." guifg="..colors[8])
end
collectgarbage()
EOF




hi! Error ctermbg=88 ctermfg=15
hi! Warning ctermbg=58 ctermfg=15



"hi! link pythonBuiltinFunction Functions
"hi! link pythonBuiltinFunc     Functions
"hi! link pythonBuiltinType     Functions
"hi! link pythonClassVar        Functions
"hi! link pythonFunction        Function
"hi! link pythonFunctionCall    FunctionCall
"hi! link pythonClass           Typedef
"hi! link pythonRepeat          Repeat
"hi! link pythonCondition       Conditional

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


"hi! CocHintSign       guibg=#111f28 guifg=#445577

hi! Warn    guibg=#221100 guifg=#cc8800 gui=None
hi! link ALEError          Error
hi! link ALEErrorSign      Error
hi! link ALEInfo          hint
hi! link ALEInfoSign      hint
hi! link CocErrorHighlight ErrorInline
hi! link CocErrorSign      Error
hi! link CocHintHighlight hint
hi! link CocHintSign      hint
hi! link DiagnosticFloatingError Error
hi! link DiagnosticFloatingHint hint
hi! link DiagnosticFloatingInfo hint
hi! link DiagnosticFloatingWarn Warn
hi! link DiagnosticSignError Error
hi! link DiagnosticSignHint hint
hi! link DiagnosticSignInfo hint
hi! link DiagnosticSignWarn Warn
hi! link DiagnosticVirtualTextError Error
hi! link DiagnosticVirtualTextHint hint
hi! link DiagnosticVirtualTextInfo hint
hi! link DiagnosticVirtualTextWarn Warn
hi! link DiagnosticVirtualTextWarn Warn
hi! link DiagnosticWarn Warn
hi! link ErrorMsg          Error
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

