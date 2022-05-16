skey() {

    set -x
    KEYS=$HOME/.ssh/keys
    SESS=$HOME/.local/tmp/skey.info
    LIFE=43200 #12 hours

    mkdir -p $KEYS $(dirname ${SESS})
    [[ "$1" == "--" ]] && return 0

    # List fi no key name was provided
    if [[ -z "$1" ]] || [[ ! -f "${KEYS}/$1" ]]; then
        for i in $KEYS/* ; do echo $(basename ${i%%.pub}) ; done
        return 0
    fi

    if [[ -z "$SSH_AGENT_PID" ]] ||\
       [[ -z "$SSH_AUTH_SOCK" ]] ||\
       [[ ! -d "/proc/$SSH_AGENT_PID" ]] ||\
       [[ ! -f "$SSH_AUTH_SOCK" ]]; then
        ssh-agent -t $LIFE > $SESS
        . $SESS
    fi
    ssh-add -t $LIFE "${KEYS}/$1"
}

skey --

