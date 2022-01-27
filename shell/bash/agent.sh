_complete_skey() {
	local cur=${COMP_WORDS[$COMP_CWORD]}
	COMPREPLY=()
	local x matches=()
	KEYS=$HOME/.ssh/keys
	local list=($(for i in $KEYS/*.pub; do echo "$(basename ${i%%.pub})"; done;))
	local IFS=""
	local c=0
	for x in ${list[@]}; do
		if [[ "$x" == "$cur"* ]]; then
			COMPREPLY[$c]="$x"
			c=$((c + 1))
		fi
	done
	export COMPREPLY
}


complete -F _complete_skey skey
