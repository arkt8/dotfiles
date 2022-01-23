hi! link yamlTSField Structure

au BufEnter,BufNewFile,BufRead *.yaml,*.yml setlocal ts=2 sts=2 sw=2 expandtab
au FileType yaml,yml setlocal ts=2 sts=2 sw=2 expandtab
