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
run "gpaste"
run "/etc/xdg/autostart/polkit-mate-authentication-agent-1."
#run "mate-volume-control-status-icon"
#add run "application" to add it in startup
