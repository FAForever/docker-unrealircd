#!/bin/bash

#
# Starts unrealircd and loops as long as it runs
#

/home/unreal/unrealircd/unrealircd start

while true
do
	if pgrep -f unrealircd 1> /dev/null;then
		sleep 1
	else
		echo SERVER CRASHED
		exit 1
	fi
done
