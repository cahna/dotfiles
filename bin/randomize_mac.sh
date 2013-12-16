#!/usr/bin/env bash

# Put this script in /etc/wicd/preconnect

connection_type="$1"

if [[ "${connection_type}" == "wireless" ]]; then
  ip link set wlp3s0 down
  macchanger -e wlp3s0
  ip link set wlp3s0 up
elif [[ "${connection_type}" == "wired" ]]; then
  ip link set enp0s25 down
  macchanger -e enp0s25
  ip link set enp0s25 up
fi

