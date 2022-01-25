colorscheme() {
	$HOME/.config/alacritty/updateconf.sh $1
}

log() {
	vim ~/Notes/ark/log/$(date +"%Y%m").md -c 'set ft=tnote'
}

note() {
	cd ~/Notes/
	vim inbox/$1
	cd -
}

kxmn_worker() { termux kxmn-worker "$@"; }
kxmn_media() { termux kxmn-media "$@"; }
kxmn_dev() { termux kxmn-dev "$@"; }

termux() {
	host="$1"
	key=~/.ssh/keys/kxmn-termux-key
	shift 1
	if [[ "$1" == 'push' ]] ; then
		shift 1
		scp -P 8022 -i $key "$1" "x@$host:$2"

	elif [[ "$1" == 'pull' ]]; then
		shift 1
		scp -P 8022 -i $key "$x$host:$1" "$2"
	else
		TERM=xterm-256color ssh -p 8022 -i ${key} x@$host
	fi
}


backlight() {
	if [[ $1 -gt 30 ]]; then
		echo $1 > /sys/class/backlight/intel_backlight/brightness
	else
		cat /sys/class/backlight/intel_backlight/max_brightness
	fi
}

