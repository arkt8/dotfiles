set shortmess+=c
set updatetime=300
" set cmdheight=2
set hidden
set signcolumn=number

if &diff == v:false " && $SSH_CONNECTION == ""
  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
      call CocActionAsync('doHover')
    else
      execute '!' . &keywordprg . " " . expand('<cword>')
    endif
  endfunction

inoremap <silent><expr> <c-space> coc#refresh()

  " Make <Tab> auto-select the first completion item and notify coc.nvim to
  " format on enter, <cr> could be remapped by other vim plugin
  inoremap <silent><expr> <tab> pumvisible() ? coc#_select_confirm()
                 \: "\<C-g>u\<tab><c-r>=coc#on_enter()\<CR>"


  " Use `[g` and `]g` to navigate diagnostics
  " Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
  nmap <silent> [g <Plug>(coc-diagnostic-prev)
  nmap <silent> ]g <Plug>(coc-diagnostic-next)

  nmap <silent> ;D :CocDisable <Enter>
  nmap <silent> ;R :CocRestart <Enter>
  nmap <silent> ;E :CocEnable <Enter>
  nmap <silent> ;l :CocList <Enter>
  nmap <silent> ;rb :CocRebuild <Enter>
  nmap <silent> ;. :CocDiagnostics <Enter>
  nmap <silent> ;/ :CocOutline <Enter>
  nmap <silent> ;; <Plug>(coc-codelens-action)
  " GoTo code navigation.
  nmap <silent> ;x :CocCommand explorer<Enter>
  nmap <silent> ;f <Plug>(coc-format)
  nmap <silent> ;d <Plug>(coc-definition)
  nmap <silent> ;y <Plug>(coc-type-definition)
  nmap <silent> ;i <Plug>(coc-implementation)
  nmap <silent> ;r <Plug>(coc-references)
  "set statusline=%m\ %f%=\ %c:%l\ \ \ %P\ \ \ %y
  set statusline=%l:%c\ %m\ %<%f%=
  set statusline+=\ %{coc#status()}%{get(b:,'coc_current_function','')}
  set statusline+=\ <\ %Y
  "set statusline=%{coc#status()}%{get(b:,'coc_current_function','')} 

  " Use K to show documentation in preview window.
  nnoremap <silent>K :call <SID>show_documentation()<CR>

  nnoremap <nowait><expr> <C-Down> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-Down>"
  nnoremap <nowait><expr> <C-Up> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-Up>"
  inoremap <nowait><expr> <C-Down> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<C-Down>"
  inoremap <nowait><expr> <C-Up> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<C-Up>"
  vnoremap <nowait><expr> <C-Down> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-Down>"
  vnoremap <nowait><expr> <C-Up> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-Up>"

  " Use CTRL-S for selections ranges.
  " Requires 'textDocument/selectionRange' support of language server.
  nmap <silent> <C-s> <Plug>(coc-range-select)
  xmap <silent> <C-s> <Plug>(coc-range-select)
endif
