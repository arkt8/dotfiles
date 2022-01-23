#!/bin/bash
xrdir=$(realpath $(dirname $0)/../xresources)
xconffile=$HOME/.Xresources

#xset +fp $HOME/.config/git/bitmap-fonts/terminus
#xset +fp $HOME/.config/git/bitmap-fonts/spleen


xrdb -remove
cat $HOME/.cache/wal/colors.Xresources > $xconffile
for conf in ${xrdir}/* ; do
	cat $conf
done >> $HOME/.Xresources

xrdb -load $HOME/.Xresources
