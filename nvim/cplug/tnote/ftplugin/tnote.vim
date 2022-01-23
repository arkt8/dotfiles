fu! s:Tnote()
	hi! tnoteItalic           cterm=italic        gui=italic
	hi! tnoteBold             cterm=bold          gui=bold
	hi! tnoteDelete           cterm=strikethrough gui=strikethrough
"	hi! link tnoteItemBullet   
	hi! link tnoteComment      Comment
	hi! link tnoteCode         String
	hi! link tnoteCodeline     String
	hi! link tnoteHeader       Title
	hi! link tnoteTag          Include
	hi! link tnoteRelation     Include
	hi! link tnoteItemBullet   TypeDef
	"hi! link tnoteItem         N
endfu

augroup Tnote
    " These autocmd calling s:MarkdownRefreshSyntax need to be kept in sync with
    " the autocmds calling s:MarkdownSetupFolding in after/ftplugin/markdown.vim.
    autocmd! * <buffer>
    autocmd BufWinEnter             <buffer> call s:Tnote()
    autocmd BufWritePost            <buffer> call s:Tnote()
    autocmd InsertEnter,InsertLeave <buffer> call s:Tnote()
    autocmd CursorHold,CursorHoldI  <buffer> call s:Tnote()
augroup END

augroup Mkd
	autocmd! * <buffer>
augroup END

call s:Tnote()
