command! GitBlame :execute "!echo;echo;x=$(git blame -L ".line(".")." % | head -n1);echo $x;git show --format=format:\"\\%s\" $(echo $x|cut -d' ' -f1)|head -n1"
command! GitShow :execute "!git --no-pager show  $(echo '".getline(line("."))."'| cat -- | sed '1,$s/^.*\\(\\b[0-9a-f]\\+\\b\\).*$/\\1/g') | head"
command! GitAdd :w! | :execute "!git add %" | :qa!

" vim: foldenable foldmethod=marker foldmarker={{{,}}}
