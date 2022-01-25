vol() {
	curvol=($(termux-volume | grep -A2 music | cut -d':' -f2 | sed 's/[",]//g'))
	if [[ "$1" == '+' ]]; then
		termux-volume music $(( ${curvol[1] + 1 ))
	elif [[ "$1" == '-' ]]; then
		termux-volume music $(( ${curvol[1] - 1 ))
	elif [[ -n $1 ]]; then
		termux-volume music $1
	else
		echo max-vol: ${curvol[2]} / actual: ${curvol[1]}
	fi
}


