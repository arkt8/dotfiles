
alias docker='sudo docker'
alias cdgit='cd $(git worktree list  --porcelain | grep "^worktree"| cut -d" " -f2-)'
alias l='/usr/bin/exa --group-directories-first --color=auto'
alias kli='sudo /kxmn/loja/srv/run'
alias tree='tree --dirsfirst -v'


rgl() {
	rg -p $@ | less -r
}

alias stackd='stack exec -- ghcid -a'
alias t='/usr/bin/translate -d -a -t pt'
alias mpv-inverted='/usr/bin/mpv --vf=sub,lavfi="negate"'