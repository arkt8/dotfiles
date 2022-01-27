#!/bin/bash
# Set the prompt colors
__OK="\001$(tput setaf 42)\002"
__ERR="\001$(tput setaf 197)\002"
__DIM="\001$(tput setaf 7)\002"
__BRI="\001$(tput setaf 15)\002"
__RESET="\001$(tput sgr0)\002"
__BOLD="\001$(tput bold)\002"

__PSOK() {
	if [[ "$?" == "0" ]];
	then echo -e "$__OK;)"
	else echo -e "$__ERR:("
	fi
}

PS1="\n$__BOLD\$(__PSOK)$__RESET $__DIM\w$__BOLD$__BRI >$__RESET "
