#!/bin/sh

state=`cat /sys/devices/platform/smapi/BAT0/state`
if [ "$state" = 'discharging' ];
  then batt=`cat /sys/devices/platform/smapi/BAT0/remaining_percent`
  if (($batt <= 30));
    then if (($batt <= 10));
      then notify-send -u critical "Battery is low! `acpi -b | tail -c 24 | head -c 10` remaining" ;
      else notify-send "Battery is Critical! `acpi -b | tail -c 24 | head -c 10` remaining" ;
    fi
  fi
fi
