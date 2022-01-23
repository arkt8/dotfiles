#!/bin/bash
CWD=$(realpath $(dirname $0))
export lnd='ln -nsfv'
# Shell
$lnd $CWD/shell/profile        $HOME/.profile
$lnd $CWD/shell/bashrc         $HOME/.bashrc
$lnd $CWD/shell/zshrc          $HOME/.zshrc
$lnd $CWD/shell/source/aliases $HOME/.bash_aliases
$lnd $CWD/tmux.conf            $HOME/.tmux.conf

# Desktop
$lnd $CWD/X/screenlayout $HOME/.screenlayout
$lnd $CWD/X/Xresources   $HOME/.Xresources
$lnd $CWD/X/Xdefaults    $HOME/.Xdefaults
$lnd $CWD/X/xsession     $HOME/.xsession
$lnd $CWD/X/themes       $HOME/.themes

$lnd $CWD/rofi           $HOME/.config/rofi
$lnd $CWD/ranger         $HOME/.config/ranger
$lnd $CWD/desktop        $HOME/.config/desktop
$lnd $CWD/wal            $HOME/.cache/wal
$lnd $CWD/bat            $HOME/.config/bat

# Fonts
mkdir -p $HOME/.fonts
$lnd $CWD/fonts/*        $HOME/.fonts/
$lnd $CWD/bitmap-fonts   $HOME/.config/bitmap-fonts

# Apps for web
mkdir -p $HOME/.local/share/luakit
$lnd $CWD/luakit         $HOME/.config/luakit
$lnd $CWD/userstyles     $HOME/.local/share/luakit/styles
$lnd $CWD/userscripts    $HOME/.local/share/luakit

for mozprofile in $HOME/.mozilla/firefox/*.default*; do
	if [ -d "$mozprofile" ]; then
		for i in $CWD/firefox/*; do
			target="$mozprofile/$(basename $i)"
			if [[ ! -e $target ]] || [[ -L $target ]]; then
				$lnd $CWD/firefox/* "$target"
			else
				echo '########################################'
				echo "ERROR: $target exists and is not a link."
				echo "Get or remove contents before continue"
				exit
			fi
		done
	fi
done

# Utilities
$lnd $CWD/bin    $HOME/.bin
$lnd $CWD/mpv    $HOME/.config/mpv
$lnd $CWD/kitty  $HOME/.config/kitty

# Editor 
$lnd $CWD/nvim   $HOME/.config/nvim
