#!/usr/bin/env bash

function run {
  if ! pgrep -f $1 ;
  then
    $@&
  fi
}

run xscreensaver -no-splash
run urxvtd
run redshift
run thunar --daemon
run conky --daemonize --pause=4

