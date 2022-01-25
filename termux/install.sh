#!/bin/bash
CWD=$(realpath $(dirname $0))
BIN=$PREFIX/bin

export lnd='ln -nsfv' 

$lnd $CWD/sh/bashrc $HOME/.bashrc
$lnd $CWD/colors $HOME/.termux/colors
$lnd $CWD/termux.properties $HOME/.termux/termux.properties

