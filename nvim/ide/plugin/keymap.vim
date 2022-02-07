fu! ResetKeymap()

  " Togglers :<
  noremap ,l :call ToggleShowLineNumber()<cr>
  noremap ,q :cn<cr>
  " >:

  inoremap  <silent> <F5>   :call Refresh()a
  noremap   <silent> <F5>   :call Refresh()
  " Backspace
  set backspace=indent,eol,start
    "On terminal vim doesn't understand <C-BS>, but <C-h> instead
    imap <C-h> <Esc>hbedbdwi

  " Terminal
  map  <A-t>    :vs<RETURN>:term<RETURN>i
  tmap <A-t>    <C-\><C-N>:vs<RETURN>:term<RETURN>i
  imap <A-S-t>  <ESC>:sp<RETURN>:term<RETURN>
  map  <A-S-t>  :sp<RETURN>:term<RETURN>
  tmap <A-S-t>  <C-\><C-N>:sp<RETURN>:term<RETURN>
  tmap <A-q>    <C-\><C-N>:q<RETURN>
  tmap <A-Left> <C-\><C-N><C-w><C-h>
  tmap <A-Right> <C-\><C-N><C-w><C-j>
  tmap <A-Esc> <C-\><C-N>

" Clipboard
" ( Ctrl + Insert )  Copy
" ( Alt + Insert )   Copy
" ( Shift + Insert ) Paste
  " COPY = copy selection on visual mode with <Ctrl+Insert>
  vmap <C-Insert> "*ygv"zy`>
  vmap <M-Insert> "*ygv"zy`>

  " PASTE = paste on all modes with <Shift+Insert>
  nmap <S-Insert> "zgP
  cmap <S-Insert> <C-r><C-o>z
  imap <S-Insert> <C-r><C-o>z
  vmap <S-Insert> "zp`]

" Quickfix
  nmap <silent> <Leader>qq :cw<cr>
  nmap <silent> <Leader>qn :cn<cr>
  nmap <silent> <Leader>qp :cp<cr>
  nmap <silent> <Leader>q' :.cc<cr>



" Opened Files navigation:
" ( Alt > ) or ( Alt < ) Next/Prev Buffer
" ( Alt ] ) or ( Alt [ ) Next/Prev Tab
" ( Alt → ) or ( Alt ← ) Right/Left Split
" ( Alt ↑ ) or ( Alt ↓ ) Up/Down Split

  " Previous Buffer (Alt + "<")
  map      <silent> <M-,>  :bprev
  noremap  <silent> <M-,>  :bprev
  inoremap <silent> <M-,>  :w!:bprevi

  " Next Buffer (Alt + ">")
  map      <silent> <M-.>  :bnext
  noremap  <silent> <M-.>  :bnext
  inoremap <silent> <M-.>  :w!:bnexti

  " Manage tabs
  map <silent> td :tabnew %<Enter>
  map <silent> tn :tabnew<Enter>
  map <silent> tq :tabclose<Enter>
  map <silent> t, :tabprev<Enter>
  map <silent> t. :tabnext<Enter>

  "" Splits
  map <silent> <M-Up>    <C-w><Up>
  map <silent> <M-Right> <C-w><Right>
  map <silent> <M-Down>  <C-w><Down>
  map <silent> <M-Left>  <C-w><Left>

  tnoremap <silent> <A-Up>     <C-\><C-N><C-w><Up>
  tnoremap <silent> <A-Right>  <C-\><C-N><C-w><Right>
  tnoremap <silent> <A-Down>   <C-\><C-N><C-w><Down>
  tnoremap <silent> <A-Left>   <C-\><C-N><C-w><Left>
  tnoremap <silent> <C-w><C-w> <C-\><C-n><C-w><C-w>

  " Open new splits easily
  map <silent> sv <C-W>v
  map <silent> sh <C-W>s
  map <silent> sq <C-W>q
  


" Cursor Navigation  

  " Home/End Shortcuts 
  map   <S-LEFT> <Home>
  imap  <S-LEFT> <Home>
  map   <S-RIGHT> <End>
  imap  <S-RIGHT> <End>

  " Up and down that works on linewraps
  "imap  <Down> gja
  "imap  <Up>   gka
  "nmap  <Down> gj
  "nmap  <Up>   gk

  " Smart manual identation
  vnoremap > >gv
  vnoremap <lt> <lt>gv

  " File type specific
  map  <F12> :Make

  " Disable column color
  set colorcolumn=

"  source $HOME/.config/nvim/macros.vim
  nmap <silent> ;d :CocDisable <Enter>
  nmap <silent> ;e :CocEnable <Enter>
  nmap <silent> ;l :CocList <Enter>
  nmap <silent> ;R :CocRestart <Enter>
  nmap <silent> ;r :CocRebuild <Enter>

  nmap <silent> ;; <Plug>(coc-codelens-action)
  nmap <silent> ;. :CocDiagnostics <Enter>
  nmap <silent> ;/ :CocOutline <Enter>


endfunction

fu ToggleShowLineNumber()
  if &number | set nonumber | else | set number | endif
endfu

:call ResetKeymap()

" vim : foldmethod=marker foldmarker=:<,>:
