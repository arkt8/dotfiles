#!/bin/bash
CWD=$(realpath $(dirname $0))
BIN=$PREFIX/bin
TERMUXDIR=$HOME/.termux

mkdir -p $BIN $TERMUXDIR

inst() {
	rm -rf $2
	mkdir -p "$(dirname "$2")"
	ln -nsfv "$1" "$2"
}

inst $CWD/sh/bashrc $HOME/.bashrc
inst $CWD/colors $TERMUXDIR/colors
inst $CWD/termux.properties $TERMUXDIR/termux.properties

