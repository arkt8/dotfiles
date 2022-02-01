":hi! link Folded Title
:hi Title gui=bold
:hi htmlH1 ctermfg=9 guifg=#edb443 gui=bold
:hi htmlH2 ctermfg=9 guifg=#edb443
:hi htmlH3 ctermfg=9 guifg=#d26937 gui=bold
:hi htmlH4 ctermfg=9 guifg=#d26937
:hi htmlH5 ctermfg=1 guifg=#c23127 gui=bold
:hi htmlH6 ctermfg=1 guifg=#c23127

:hi htmlBold       guifg=NONE gui=bold
:hi htmlItalic     guifg=NONE gui=italic
:hi htmlBoldItalic guifg=NONE gui=bold,italic
:hi htmlLink       guifg=SeaGreen guibg=NONE gui=NONE
:hi htmlStrike     gui=strikethrough
:hi mkdRule        gui=strikethrough,bold,italic

:hi! link htmlH1 Number
:hi! link htmlH2 Identifier
:hi! link htmlH3 Delimiter
:hi! link htmlH4 Operator
:hi! link htmlStrike Comment
:hi! link htmlLink htmlPreAttr

:setlocal wrap linebreak breakindent lines
g:vim_markdown_anchorexpr = "'<<'.v:anchor.'>>'"
setlocal conceallevel=2
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_follow_anchor = 1
let g:vim_markdown_autowrite = 1
let g:vim_markdown_edit_url_in = 'tab'
" let g:vim_markdown_edit_url_in = 'vsplit'
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_override_foldtext = 0


setlocal ts=2 sts=2 sw=2 ai et
