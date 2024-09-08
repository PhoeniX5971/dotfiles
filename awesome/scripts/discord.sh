if pgrep -x "Discord" >/dev/null; then
  killall Discord && discord &
fi
