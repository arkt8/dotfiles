#!/bin/bash

action="$1"
shift;

input() {
	. $HOME/.cache/wal/colors.sh
	rofi -dmenu -lines 0 -p "$@"
}
rofi_desktop() {
	. $HOME/.cache/wal/colors.sh
	wallpaper=wallpaper:$HOME/.config/rofi/apps/wallpaper
	theme=theme:$HOME/.config/rofi/apps/theme
	rofi -sidebar-mode true \
		-show theme \
		-matching regex \
		-modi window,$wallpaper,$theme
}
rofi_todo() {
	. $HOME/.cache/wal/colors.sh
	rofi -sidebar-mode true \
		-show notes \
		-modi notes:$HOME/.config/rofi/apps/notes
}

rename_current_window() {
#	window=$(xwininfo | grep 'xwininfo: Window id' | awk '{print $4}')
	window=$(xdotool getactivewindow)
	name=$(input 'Window title')
	xdotool set_window --name "${name}" "${window}"
}


case "$action" in

 "rename_workspace") i3-msg rename workspace to "$( input 'Workspace name')";;
 #"rename_window")    i3-msg title_format "$(input 'Window title')";;
 "rename_window")    rename_current_window ;;
 "mark_add")         i3-msg mark "$(input "Add mark")";;
 "mark_focus")       i3-msg "[con_mark=\"$(input "Go to mark")\"] focus";;
 "wm_menu")          rofi_desktop ;;
 "todo")             rofi_todo ;;
 "theme")            wpg --noreload
esac
