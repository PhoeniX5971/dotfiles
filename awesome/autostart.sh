#! /bin/bash

$HOME/.config/awesome/other/picom/launch.sh --opacity &
pgrep -x polkit-gnome-au >/dev/null || /usr/libexec/polkit-gnome-authentication-agent-1 &
pgrep -x greenclip >/dev/null || $HOME/.config/awesome/other/bin/greenclip daemon &
pkill xsettingsd &
while pgrep -u $UID -x xsettingsd >/dev/null; do sleep 1; done
xsettingsd &
