#!/bin/bash
# Generate the includes for the `bar{ }` i3.conf include

export DESKDIR="$HOME/.config/desktop"
export CACHEDIR="$HOME/.cache/desktop"

_screens() {
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
screens=( $(_screens) )
export SCREEN_PRIMARY=${screens[1]}
export SCREEN_SECONDARY=${screens[2]}

setup_others() {
	cp $HOME/.cache/wal/colors-rofi-dark.rasi $DESKDIR/rofi.rasi
	cp $HOME/.cache/wal/colors-kitty.conf $HOME/.config/kitty/kitty.conf
}

setup_x() {
	file=$DESKDIR/xresources/99-urxvt
	tpl=$DESKDIR/templates/urxvt.xresources
	$(cat ~/.cache/wal/colors.sh | grep = | grep 'fore\|back\|color' | sed "s/^/export /g;s/['\"]//g")
	cat $WAL/colors.Xresources $tpl | envsubst >$file
	cat $DESKDIR/templates/dark.css | envsubst > $HOME/.config/dotfiles/userstyles/dark.css
	cat $DESKDIR/templates/luakit-theme.lua |envsubst > $HOME/.config/luakit/theme.lua
	cat $DESKDIR/xresources/* > $HOME/.Xdefaults

	mkdir -p $HOME/.config/zathura
	cat $DESKDIR/templates/zathura | envsubst > $HOME/.config/zathura/zathurarc

	cat $HOME/.local/share/themes/Flatabulous-wal/gtk-2.0/tplrc \
		| envsubst > $HOME/.local/share/themes/Flatabulous-wal/gtk-2.0/gtkrc

    
}

setup_xrdb(){
    xrdir=$DESKDIR/xresources
    xconffile=$HOME/.Xresources

    #xset +fp $HOME/.config/git/bitmap-fonts/terminus
    #xset +fp $HOME/.config/git/bitmap-fonts/spleen


    xrdb -remove
    cat $HOME/.cache/wal/colors.Xresources > $xconffile
    for conf in ${xrdir}/* ; do
        cat $conf
    done >> $HOME/.Xresources

    xrdb -load $HOME/.Xresources
}

setup_i3bar() {
    OUT="${CACHEDIR}/i3bar"
    mkdir -p "$OUT"
    for i in $DESKDIR/i3bar/templates/*.conf ; do
        export BARNAME="$(basename $i|cut -d. -f1)"
        cat $i | envsubst "$COLORSUBST" > "${OUT}/$(basename $i)"
    done
}


setup_cssstyles() {
	for i in $HOME/.mozilla/firefox/*.default*; do
		cat $WAL/colors.css $i/chrome/userContent.tplcss \
		  > $i/chrome/userContent.css
	done
}
setup_i3theme() {
    templateFile=$DESKDIR/i3/i3theme.conf
    cacheFile=$CACHEDIR/i3theme.conf
    rm $cacheFile

    cat $templateFile | envsubst "$COLORSUBST" > $cacheFile
}

setup_rofi() {
    templateFile=$DESKDIR/rofi/templates/default.rasi
    cacheFile=$CACHEDIR/rofi-theme.rasi

    cat $templateFile | envsubst "$COLORSUBST" > $cacheFile
}


                # Use wal + wpg + oomox
# pip3 install pywal # to install wal
# pip3 install wpgtk # to install wpg
wal -R

rm -rf "${CACHEDIR}/*"
mkdir -p "${CACHEDIR}"
. $DESKDIR/inc/colors.sh

setup_others
setup_x
setup_xrdb
setup_i3bar
setup_i3theme
setup_rofi
setup_cssstyles

