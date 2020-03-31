#!/usr/bin/env bash

# Put this script in /etc/wicd/preconnect

connection_type="$1"
WL_IF="wlp3s0"
LAN_IF="enp0s25"

if [[ "${connection_type}" == "wireless" ]]; then
  ip link set $WL_IF down
  macchanger -e $WL_IF
  ip link set $WL_IF up
elif [[ "${connection_type}" == "wired" ]]; then
  ip link set $LAN_IF down
  macchanger -e $LAN_IF
  ip link set $LAN_IF up
fi

