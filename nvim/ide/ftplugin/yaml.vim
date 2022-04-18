hi! link yamlTSField     Title
hi! link yamlTSPunctDelimiter Operator


fu! CustomYamlSyntax()
  "syntax clear yamlComment
  "#syntax match yamlCommentSign /^\s*#/ contained
  "syntax match yamlComm /^\s*#.*/ contains=yamlCommentSign
  hi! link yamlComm String
  hi! link yamlCommentSign Comment
  hi! link yamlBlockMappingKey Keyword
  echo 'lkjlkjlkjlkjlkj'
endfu

augroup YAMLSYNTAX
  au FileType,BufReadPost,FileReadPost,BufNew,VimEnter *.yaml call CustomYamlSyntax()
augroup END

setlocal ts=2 sts=2 sw=2 et


