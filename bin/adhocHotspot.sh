#!/bin/bash
usage="USAGE: sudo $0 -c 7 -w 2 wlp3s0 enp0s25 <networkname> <password>"
if [[ -z "$1" ]] || [[ -z "$2" ]]; then
  echo $usage
else
  sudo ./create_ap/create_ap -c 7 -w 2 wlp3s0 enp0s25 "$1" "$2"
fi
