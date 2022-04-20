#!/bin/bash
/home/thadeu/.local/share/luakit
TGT="$HOME/.local/share/luakit/adblock"
mkdir -p "$TGT"
LIST=(
https://easylist.to/easylist/easylist.txt
https://easylist.to/easylist/easyprivacy.txt
https://easylist.to/easylist/fanboy-social.txt
https://secure.fanboy.co.nz/fanboy-annoyance.txt
https://secure.fanboy.co.nz/fanboy-cookiemonster.txt
)
for i in ${LIST[*]}; do
    tgt="$TGT/$(basename $i)"
    rm -f $tgt
    echo "UPDATING... $i"
    curl $i > $tgt
done
