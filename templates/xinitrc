#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Refresh fonts list
xset +fp /usr/share/fonts/local
xset fp rehash

# Load xcompmgr (a composite manager needed for transparency/shadows/etc)
# UPDATE: Replaced xcompmgr with unagi
# xcompmgr -cfF -t-9 -l-11 -r9 -o.95 -D6 &
unagi &

# Load thunar as a daemon
thunar --daemon &

# Load X resources (terminal colors, etc)
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# Attach buttons/keys like audio up/down and mute
xbindkeys

# Battery level notifications (check every 5 minutes)
(while true; do sleep 300s; /home/cheine/bin/battery_warning.sh; done) &

# Enable screensaver with X
/usr/bin/xscreensaver -no-splash &

# Enable redshift-scheduler
redshift-scheduler &

# Window manager
exec awesome

