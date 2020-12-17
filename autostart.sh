#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}
run "nm-applet"
run "mate-power-manager"
run "xinput set-prop 11 333 1"
run "setxkbmap -layout us,ru -option grp:alt_shift_toggle"
run "gpaste"
run "/etc/xdg/autostart/polkit-mate-authentication-agent-1."
#run "mate-volume-control-status-icon"
