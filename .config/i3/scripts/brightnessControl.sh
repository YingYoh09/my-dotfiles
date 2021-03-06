#!/usr/bin/env bash

# You can call this script like this:
# $ ./brightnessControl.sh up
# $ ./brightnessControl.sh down

# Script inspired by these wonderful people:
# https://github.com/dastorm/volume-notification-dunst/blob/master/volume.sh
# https://gist.github.com/sebastiencs/5d7227f388d93374cebdf72e783fbd6a

function get_brightness {
  brightnessctl | grep '%' | cut -d '(' -f 2 | cut -d '%' -f 1
}

function send_notification {
  icon="/usr/share/icons/Faba/48x48/notifications/notification-display-brightness.svg"
  DIR=`dirname "$0"`
  brightness=$(get_brightness)
  # Make the bar with the special character ─ (it's not dash -)
  # https://en.wikipedia.org/wiki/Box-drawing_character
  bar=$(seq -s "─" $(($brightness/5)) | sed 's/[0-9]//g')
  # Send the notification
  $DIR/notify-send.sh "$brightness""     ""$bar" -i "$icon" -t 2000 --replace=555
  #$DIR/notify-send.sh "$brightness""     ""$bar" -i "$icon" -t 2000 -h int:value:"$brightness" -h string:synchronous:"$bar" --replace=555
}

case $1 in
  up)
    # increase the backlight by 5%
    brightnessctl s +5% --quiet
    send_notification
    ;;
  down)
    # decrease the backlight by 5%
    brightnessctl s 5%- --quiet
    send_notification
    ;;
  norm)
    # decrease the backlight by 5%
    brightnessctl s 80% --quiet
    ;;
  zero)
    # decrease the backlight by 5%
    brightnessctl s 0 --quiet
    ;;
esac
