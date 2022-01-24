#!/bin/bash

export WAL=$HOME/.cache/wal
export DESK=$HOME/.config/desktop
. $WAL/colors.sh

css_theme() {
	for i in $HOME/.mozilla/firefox/*.default*; do
		cat $WAL/colors.css $i/chrome/userContent.tplcss \
		  > $i/chrome/userContent.css
	done
}
other_theme() {
	cp $WAL/colors-rofi-dark.rasi $DESK/rofi.rasi
	cp $WAL/colors-kitty.conf $HOME/.config/kitty/kitty.conf
}


#rofi_theme() { (
#	cat $DESK/templates/rofi.rasi
#	echo '*{'
#	for c in {0..15} ; do
#		local color="color$c";
#		echo "$color : ${!color};"
#	done
#	echo '}'
#) > $DESK/rofi.rasi ; }

# On debian urxvt uses different class on configuration,
# i.e. only loads confs started with urxvt not URxvt
xthemes() {
	file=$DESK/xresources/99-urxvt
	tpl=$DESK/templates/urxvt.xresources
	$(cat ~/.cache/wal/colors.sh | grep = | grep 'fore\|back\|color' | sed "s/^/export /g;s/['\"]//g")
	echo $background
	cat $WAL/colors.Xresources $tpl | envsubst >$file
	cat $DESK/templates/dark.css | envsubst > $HOME/.config/dotfiles/userstyles/dark.css
	cat $DESK/templates/luakit-theme.lua |envsubst > $HOME/.config/luakit/theme.lua
	cat $DESK/xresources/* > $HOME/.Xdefaults
}

css_theme
xthemes
other_theme
