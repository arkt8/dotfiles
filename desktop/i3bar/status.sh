#!/bin/bash

# https://i3wm.org/docs/i3bar-protocol.html
# https://docs.gtk.org/Pango/pango_markup.html

export DESKDIR="$HOME/.config/desktop"
. $DESKDIR/inc/colors.sh

STATUSDIR="$(realpath $(dirname $0))/status"
STATUS="$1"
#exec 2> /tmp/i3bar-status-$STATUS.log
run_command() {
    if [[ "$1" == "time" ]] ; then
        return 0 # put something here someday
    fi
}

status_volume () {
    echo ',{"name":"volume",
    "color":"'$color7'",
    "markup":"pango",
    "full_text":" ♬ <small>'$(pactl get-sink-volume 0 | awk '{print $5}')'</small> "}'
}

status_weather() {
    echo ',{"name":"weather",
    "color":"'$color8'",
    "align":"center",
    "markup":"pango",
    "full_text":"<small>'$(weather)'</small>"}'
}
status_time() {
    date=($(date +"%H %M %Y %m %d %A"))
    echo ',{"name":"time",
    "background":"'$foreground'33",
    "color":"'$foreground'88",
    "markup":"pango",
    "separator_block_width":0,
    "full_text":"<small> '"${date[5]} ${date[4]}/${date[3]}/${date[2]}"' </small>"}'
    echo ',{"name":"time",
    "background":"'$color2'",
    "color":"'$color0'",
    "markup":"pango",
    "separator_block_width":0,
    "full_text":"<i><b> '"${date[0]}:${date[1]}"' </b></i>"}'
}

if [[ -f "$STATUSDIR/$STATUS" ]]; then

echo '{"version":1, "click_events":true}[[]'
    while : ; do
        echo ',[{"full_text":""}'
        . "$STATUSDIR/$STATUS"
        echo "]"
        read -t 1 cmd
        # if [[ $? -lt 1 ]] ; then
        #    run_command $(jq -rc '[.name,.button]' <<< $cmd | tr -d '[]"' | tr ',' ' ') 
        # fi
    done
fi

