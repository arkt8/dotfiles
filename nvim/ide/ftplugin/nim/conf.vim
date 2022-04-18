au BufEnter,BufRead *.py setlocal expandtab
nnoremap <buffer><silent> \x <Esc>:w!<Enter>:!nim r --spellSuggest --showAllMismatches %<Enter>
