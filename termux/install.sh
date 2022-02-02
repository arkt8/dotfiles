#!/bin/bash

FROM=$(realpath $(dirname $0))
BIN=$PREFIX/bin
TERMUXDIR=$HOME/.termux

mkdir -p $BIN $TERMUXDIR

inst() {
	rm -rf $2
	mkdir -p "$(dirname "$2")"
	ln -nsfv "$1" "$2"
}

inst $FROM/sh/bashrc         $HOME/.bashrc
inst $FROM/tmux.conf         $HOME/.tmux.conf

inst $FROM/colors            $TERMUXDIR/colors
inst $FROM/termux.properties $TERMUXDIR/termux.properties
