color() {
	path=$HOME/.termux/colors
	if [[ -z $1 ]] || [[ ! -f $path/$1.properties ]]; then
		for i in $path/*; do
			echo $(basename ${i%%.properties});
		done
	else
		cp "$path/$1.properties" "$HOME/.termux/colors.properties"
		termux-reload-settings
		neofetch --off --color_blocks on | tail -n 6
	fi
}
