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
    "color":"'$color15'44",
    "markup":"pango",
    "full_text":" ♬ <small>'$(pactl get-sink-volume 0 | awk '{print $5}')'</small> "}'
}

status_weather() {
    RAW_FILE=$HOME/.local/tmp/weather~raw.json
    DATA_FILE=$HOME/.local/tmp/weather.txt
    FILE_AGE=$(stat -c %Y ${DATA_FILE})
    if [[ $FILE_AGE -lt $((${date[0]}-1800)) ]]; then
        curl "https://api.openweathermap.org/data/2.5/onecall?units=metric&lang=pt&lat=-23.960833&lon=-46.333889&appid=01a378b7ce2b7525acc30ccc47e3e96c" > $RAW_FILE 2>/dev/null
       (head -n 30 && tail -n 10) <<< \
         $(cat $RAW_FILE \
         | sed 's/\([[:digit:]"]\),/\1\n/g;s/\],/]\n/g') > $DATA_FILE
      #  else
      #  echo ',{"name":"weather",
      #  "color":"'$foreground'88",
      #  "align":"center",
      #  "markup":"pango",
      #  "full_text":"<small>'"$FILE_AGE ${date[0]}"'</small>"}'
      #  return
    fi

    getdata() {
        echo "$(grep -m 1 "$1" $DATA_FILE | cut -d: -f2 | cut -d. -f1 | tr -d '"')"
    }

    TMP="$(getdata temp)°C/$(getdata feels_like)°C"
    COND="$(getdata description)"
    HUMI="$(getdata humidity)%"

    echo ',{"name":"weather",
    "color":"'$foreground'88",
    "align":"center",
    "markup":"pango",
    "full_text":"<small>'"${TMP}   ${HUMI}   ${COND}"'</small>"}'
}


cpuinfo() {
    head -n1 /proc/stat;sleep 0.2;head -n1 /proc/stat;
}
status_system() {
    CPU=$( cpuinfo | awk '/^cpu /{u=$2-u;s=$4-s;i=$5-i;w=$6-w}END{print int(0.5+100*(u+s+w)/(u+s+i+w))}')

    MEM=($(free | tail -n2 | awk '{printf "%.1f ", ((100 / $2) * $3)}'))

    echo ',{"name":"swap",
    "color":"'$color15'44",
    "markup":"pango",
    "separator_block_width":0,
    "full_text":" <small><small>S:</small><b>'"${MEM[1]}"'</b>%</small> · "}'
    echo ',{"name":"mem",
    "color":"'$color15'44",
    "markup":"pango",
    "separator_block_width":0,
    "full_text":" <small><small>M:</small><b>'"${MEM[0]}"'</b>%</small> · "}'
    echo ',{"name":"cpu",
    "color":"'$color15'44",
    "markup":"pango",
    "separator_block_width":0,
    "full_text":"<small><small>C:</small><b>'"${CPU}"'</b>%</small> "}'
}

status_time() {
    echo ',{"name":"date",
    "background":"'$color2'66",
    "color":"'$background'",
    "markup":"pango",
    "separator_block_width":0,
    "full_text":"<small> '"${date[6]}, ${date[5]} de ${date[4]} de ${date[3]}"' </small>"}'
    echo ',{"name":"time",
    "background":"'$color2'",
    "color":"'$color0'",
    "markup":"pango",
    "separator_block_width":0,
    "full_text":"<i><b> '"${date[1]}:${date[2]}"' </b></i>"}'
}

if [[ -f "$STATUSDIR/$STATUS" ]]; then

echo '{"version":1, "click_events":true}[[]'
    while : ; do
        export date=($(date +"%s %H %M %Y %B %d %A"))
        echo ',[{"full_text":""}'
        . "$STATUSDIR/$STATUS"
        echo "]"
        read -t 5 cmd
        # if [[ $? -lt 1 ]] ; then
        #    run_command $(jq -rc '[.name,.button]' <<< $cmd | tr -d '[]"' | tr ',' ' ') 
        # fi
    done
fi

