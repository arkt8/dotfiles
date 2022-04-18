skey() {
	set +x
	KEYS=$HOME/.ssh/keys
	SESS=$HOME/.local/tmp/skey.info
	mkdir -p $KEYS $(dirname ${SESS})
	[[ -f "$SESS" ]] && . "$SESS" > /dev/null 2>&1
	[[ "$1" == "--" ]] && return 0

	if [[ -z "$1" ]] || [[ ! -f "${KEYS}/$1" ]]; then
		for i in $KEYS/* ; do echo $(basename ${i%%.pub}) ; done
		return 0
	fi
	if [[ ! -d "/proc/$SSH_AGENT_PID" ]] ; then
		ssh-agent -t 36000 > $SESS
		. $SESS
	fi
	ssh-add "${KEYS}/$1"
}

skey --

