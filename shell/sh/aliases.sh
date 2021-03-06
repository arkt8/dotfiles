PATH=$HOME/.nimble/bin:$PATH
PATH=$HOME/.luarocks/bin:$PATH
alias bookmark='vim ~/.config/dotfiles/bookmarks.json'
alias cdgit='cd $(git worktree list  --porcelain | grep "^worktree"| cut -d" " -f2-)'
alias docker='sudo docker'
alias kli='sudo /kxmn/loja/srv/run'
alias l='/usr/bin/exa --group-directories-first --color=auto'
alias ls='ls --color=always'
alias mpv-inverted='/usr/bin/mpv --vf=sub,lavfi="negate"'
alias stackd='stack exec -- ghcid -a'
alias tree='exa --color=auto -T'
alias t='/usr/bin/translate -d -a -t pt'
alias gst='git status'
alias bat='bat --style plain'

