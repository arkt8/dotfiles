#!/bin/bash

# Use wal + wpg + oomox
# pip3 install pywal # to install wal
# pip3 install wpgtk # to install wpg

. $HOME/.dotfiles/shell/sh/environment.sh

export dir="$(realpath $(dirname $0))"
. $WAL/colors.sh

function _screens() {
	local pri
	local sec
	if type "xrandr" > /dev/null; then
		for m in $(xrandr --query | grep ' connected' | tr ' ' ':'); do
			if $(echo m | grep ':primary:' > /dev/null) ; then
				pri=$(echo $m| cut -d':' -f1)
			else
				sec=$(echo $m| cut -d':' -f1)
			fi
		done
	fi
	echo $pri $sec
}

function _polybars() {
	pkill -9 polybar
	for bar in "$@" ; do
		polybar -c $dir/polybar $bar &
	done
}

screens=( $(_screens) )
export SCREEN_PRIMARY=${screens[1]}
export SCREEN_SECONDARY=${screens[2]}
export WAL=$HOME/.cache/wal
wal -R
$dir/scripts/theme.sh
$dir/scripts/xrdb.sh

if [[ "$1" == "reload" ]]; then
	oomox-cli --output pywal -m all --hidpi False /home/thadeu/.cache/wal/colors-oomox &
	i3-msg restart
	pkill -9 polybar
	_polybars main sec
else
	_polybars main sec
	setsid -f yeahconsole ~/.bin/vim-notes > /dev/null 2>&1
fi


