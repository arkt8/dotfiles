#!/bin/bash
export ROFI="rofi -config $HOME/.config/rofi/config"
action="$1"
shift;

input() {
	. $HOME/.cache/wal/colors.sh
	$ROFI -dmenu -lines 0 -p "$@"
}

rofi_settings() {
	if [[ "$1" == "" ]]; then
		$0 settings "$($0 settings --list | $ROFI -dmenu -p "Conf")"
		exit
	fi

	declare -A O

	O["Wacom Left"]="WACOMOUTPUT=eDP-1 wacomrotate lf"
	#O["Wacom Right"]="WACOMOUTPUT=DP-1 wacomrotate p"
	O["Wacom Right"]="WACOMOUTPUT=DP-1 wacomrotate lf"

	OPTION="$*"
	set +x
	if [[ "$1" == "--list" ]] ; then
		for i in "${!O[@]}"; do
			echo $i
		done
	else
		if [[ "${O["$OPTION"]}" != "" ]]; then
			exec bash -c "${O["$OPTION"]}"
		fi
	fi
}

rofi_desktop() {
	. $HOME/.cache/wal/colors.sh
	wallpaper=wallpaper:$HOME/.config/rofi/apps/wallpaper
	theme=theme:$HOME/.config/rofi/apps/theme
	$ROFI -sidebar-mode true \
		-show theme \
		-matching regex \
		-modi window,$wallpaper,$theme
}

rofi_run() {
	$ROFI -show run -modi run,ssh,window
}

rofi_todo() {
	. $HOME/.cache/wal/colors.sh
	$ROFI -sidebar-mode true \
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
 "theme")            wpg --noreload ;;
 "settings")         rofi_settings $@ ;;
 "run")              rofi_run $@;;
esac
